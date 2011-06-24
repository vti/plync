package Plync::Command::Sync;

use strict;
use warnings;

use base 'Plync::Command::Base';

sub _dispatch {
    my $self = shift;

    my $collections = $self->req->collections;

    sub {
        my $done = shift;

        if ($collections->[0]->{sync_key} eq '0') {
            return $self->_dispatch_initial($done);
        }

        $self->device->fetch_folder(
            $collections->[0]->{collection_id},
            sub {
                my $backend = shift;
                my ($folder) = @_;

                if (!$folder) {
                    $self->res->status(12);
                    return $done->();
                }

                if ($folder->checksum eq $collections->[0]->{sync_key}) {
                    if (my $commands = $collections->[0]->{commands}) {
                        return $self->_dispatch_commands($commands, $folder,
                            $done);
                    }
                    else {
                        return $self->_dispatch_fetch_folder_items($folder,
                            $done);
                    }
                }
                else {
                    $self->_dispatch_resync_needed($folder);
                    return $done->();
                }
            }
        );
      }
}

sub _dispatch_initial {
    my $self = shift;
    my ($done) = @_;

    my $id = $self->req->collections->[0]->{collection_id};

    $self->device->fetch_folder(
        $id => sub {
            my $backend = shift;
            my ($folder) = @_;

            if (!$folder) {
                $self->res->status(12);
                return $done->();
            }

            $self->res->add_collection(
                status        => 1,
                collection_id => $folder->id,
                class         => $folder->class,
                sync_key      => $folder->checksum
            );

            $done->();
        }
    );
}

sub _dispatch_commands {
    my $self = shift;
    my ($commands, $folder, $done) = @_;

    if ($commands->[0] eq 'fetch') {
        my $item_id = $commands->[1]->{server_id};

        return $self->_dispatch_fetch_folder_item($folder, $item_id, $done);
    }
    else {
        die 'TODO';
    }
}

sub _dispatch_resync_needed {
    my $self = shift;
    my ($folder) = @_;

    $self->res->add_collection(
        status        => 3,
        collection_id => $folder->id,
        class         => $folder->class,
        sync_key      => 0
    );
}

sub _dispatch_fetch_folder_items {
    my $self = shift;
    my ($folder, $done) = @_;

    $self->device->fetch_folder(
        $folder->id,
        items => 1,
        sub {
            my $backend = shift;
            my ($folder) = @_;

            # TODO check if folder exists

            my @commands;

            foreach my $item (@{$folder->items}) {
                push @commands, add => {
                    server_id        => $item->id,
                    status           => 1,
                    application_data => $item
                };
            }

            $self->res->add_collection(
                status        => 1,
                collection_id => $folder->id,
                class         => $folder->class,
                sync_key      => $folder->checksum,
                commands      => [@commands]
            );

            $done->();
        }
    );
}

sub _dispatch_fetch_folder_item {
    my $self = shift;
    my ($folder, $item_id, $done) = @_;

    $self->device->fetch_folder_item(
        $folder, $item_id,
        sub {
            my $backend = shift;
            my ($item) = @_;

            if (!$item) {
                die "TODO";
            }

            $self->res->status(1);

            $self->res->add_collection(
                status        => 1,
                collection_id => $folder->id,
                class         => $folder->class,
                sync_key      => $folder->checksum,
                responses     => [
                    fetch => {
                        server_id        => $item->id,
                        status           => 1,
                        application_data => $item
                    }
                ]
            );

            $done->();
        }
    );
}

1;
