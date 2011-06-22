package Plync::Command::FolderSync;

use strict;
use warnings;

use base 'Plync::Command::Base';

sub _dispatch {
    my $self = shift;

    if (my $error = $self->req->error) {
        $self->res->status($error);
        return;
    }

    my $device = $self->device;

    sub {
        my $done = shift;

        if ($self->req->sync_key eq '0') {
            return $device->fetch_folders(
                sub {
                    my $device = shift;
                    my ($folders) = @_;

                    $self->_dispatch_initial($folders);

                    $done->();
                }
            );
        }

        if (   $device->folder_set
            && $device->folder_set->sync_key eq $self->req->sync_key)
        {
            $self->_dispatch_no_changes;
        }
        else {
            $self->_dispatch_resync_needed;
        }

        $done->();
    }
}

sub _dispatch_initial {
    my $self = shift;
    my ($folders) = @_;

    foreach my $folder (@{$folders->list}) {
        $self->res->add_folder(
            server_id    => $folder->id,
            parent_id    => $folder->parent_id,
            type         => $folder->type,
            display_name => $folder->display_name
        );
    }

    $folders->synced;
    $self->res->sync_key($folders->sync_key);
}

sub _dispatch_no_changes {
    my $self = shift;

    # TODO

    my $folder_set = $self->device->folder_set;

    $folder_set->synced;
    $self->res->sync_key($folder_set->sync_key);
}

sub _dispatch_resync_needed {
    my $self = shift;

    $self->res->status(9);
    $self->res->sync_key(0);
}

1;
