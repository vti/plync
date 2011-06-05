package Plync::Command::Sync;

use strict;
use warnings;

use base 'Plync::Command::Base';

use Plync::Folders;
use Plync::Data::Email;

sub _dispatch {
    my $self = shift;

    #use Data::Dumper;
    #warn Dumper $self->req;

    my $collections = $self->req->collections;

    my $folders = Plync::Folders->load;

    if ($collections->[0]->{sync_key} eq '0') {
        my $folder =
          $folders->load_folder($collections->[0]->{collection_id});

        if (!$folder) {
            $self->res->status(12);
            return;
        }

        $folder->synced;

        $self->res->add_collection(
            status        => 1,
            collection_id => $folder->id,
            class         => $folder->class,
            sync_key      => $folder->sync_key
        );

        return;
    }

    my $folder = $folders->load_folder($collections->[0]->{collection_id});

    if (!$folder) {
        $self->res->status(12);
        return;
    }

    if ($folder->sync_key eq $collections->[0]->{sync_key}) {
        if (my $commands = $collections->[0]->{commands}) {
            use Data::Dumper;
            warn Dumper $commands;

            my $object = $folder->load_object(123);

                #$folder->synced;

            if ($commands->[0] eq 'fetch') {
                my $server_id = $commands->[1];

                $self->res->status(1);

                $self->res->add_collection(
                    status        => 1,
                    collection_id => $folder->id,
                    class         => $folder->class,
                    sync_key      => $folder->sync_key,
                    responses     => [
                        fetch => {
                            server_id => $object->id,
                            status    => 1,
                            application_data => $object
                        }
                    ]
                );
            }
            else {
                die 'TODO';
                #$self->res->add_collection(
                #    status        => 1,
                #    collection_id => $folder->id,
                #    class         => $folder->class,
                #    sync_key      => $folder->sync_key,
                #    responses     => [
                #        change => {
                #            server_id => '123',
                #            status    => 1
                #        }
                #    ]
                #);
            }
        }
        else {
            $folder->synced;

            my $objects = $folder->load_objects;

            my @commands;

            foreach my $object (@$objects) {
                push @commands, add => {
                    server_id        => $object->id,
                    status           => 1,
                    application_data => $object
                };
            }

            $self->res->add_collection(
                status        => 1,
                collection_id => $folder->id,
                class         => $folder->class,
                sync_key      => $folder->sync_key,
                commands      => [@commands]
            );
        }
    }
    else {
        $folder->reset;

        $self->res->add_collection(
            status        => 3,
            collection_id => $folder->id,
            class         => $folder->class,
            sync_key      => $folder->sync_key
        );
    }

    #warn Dumper $self->res;
}

1;
