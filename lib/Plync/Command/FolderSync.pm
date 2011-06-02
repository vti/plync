package Plync::Command::FolderSync;

use strict;
use warnings;

use base 'Plync::Command::Base';

use Plync::Folders;

sub _dispatch {
    my $self = shift;

    if (my $error = $self->req->error) {
        $self->res->status($error);
        return;
    }

    my $folders = Plync::Folders->load;

    if ($self->req->sync_key eq '0') {
        foreach my $folder (@{$folders->folders}) {
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
    elsif ($folders->sync_key eq $self->req->sync_key) {
        $self->res->sync_key($folders->sync_key);

        # TODO
    }
    else {
        # TODO
        $self->res->status(9);
        $self->res->sync_key(0);
    }
}

1;
