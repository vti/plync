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

        # TODO check if folder exists

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

    ## TODO check if collection exists

    if ($folder->sync_key eq $collections->[0]->{sync_key}) {
        my $email = Plync::Data::Email->new(
            id            => 123,
            to            => '"Device User" <deviceuser@example.com>',
            from          => '"Device User 2" <deviceuser2@example.com>',
            subject       => 'New mail message',
            date_received => '2009-07-29T19:25:37.817Z',
            display_to    => 'Device User',
            thread_topic  => 'New mail message',
            importance    => 1,
            read          => 0,
            body          => {
                type                => 2,
                estimated_data_size => 116575,
                truncated           => 1
            },
            message_class      => 'IPM.Note',
            internet_CPID      => '1252',
            content_class      => 'urn:content-classes:message',
            native_body_type   => '2',
            conversation_id    => 'FF68022058BD485996BE15F6F6D99320',
            conversation_index => 'CA2CFA8A23'
        );

        $self->res->add_collection(
            status        => 1,
            collection_id => $folder->id,
            class         => $folder->class,
            sync_key      => $folder->sync_key,
            commands      => [
                add => {
                    server_id        => $folder->id . ':' . $email->id,
                    application_data => $email
                }
            ]
        );
    }
    else {
        $folder->reset;

        $self->res->add_collection(
            status        => 3,
            collection_id => $folder->id,
            class         => $folder->class,
            sync_key      => 0
        );
    }

    #warn Dumper $self->res;
}

1;
