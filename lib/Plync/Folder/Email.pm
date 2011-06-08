package Plync::Folder::Email;

use strict;
use warnings;

use base 'Plync::Folder::Base';

use Plync::Data::Email;

sub load_object {
    my $self = shift;
    my ($id) = @_;

    return Plync::Data::Email->new(
        id            => $id,
        to            => '"Device User" <deviceuser@example.com>',
        from          => '"Device User 2" <deviceuser2@example.com>',
        subject       => 'New mail message',
        date_received => '2009-07-29T19:25:37.817Z',
        display_to    => 'Device User',
        thread_topic  => 'New mail message',
        importance    => 1,
        read          => 0,
        body          => {
            type => 2,

            #estimated_data_size => 116575,
            truncated => 0,
            data      => 'Hello there123'
        },
        message_class      => 'IPM.Note',
        internet_CPID      => '1252',
        content_class      => 'urn:content-classes:message',
        native_body_type   => '2',
        conversation_id    => 'FF68022058BD485996BE15F6F6D99320',
        conversation_index => 'CA2CFA8A23'
    );
}

sub load_objects {
    my $self = shift;

    return [
        Plync::Data::Email->new(
            id            => 123,
            to            => '"Device User" <deviceuser@example.com>',
            from          => '"Device User 2" <deviceuser2@example.com>',
            subject       => 'New mail message',
            date_received => '2009-07-29T19:25:37.817Z',
            display_to    => 'Device User',
            thread_topic  => 'New mail message',
            importance    => 1,
            read          => 1,
            body          => {
                type                => 2,
                estimated_data_size => 11,
                truncated           => 0,
                data => 'Hello there'
            },
            message_class      => 'IPM.Note',
            internet_CPID      => '1252',
            content_class      => 'urn:content-classes:message',
            native_body_type   => '2',
            conversation_id    => 'FF68022058BD485996BE15F6F6D99320',
            conversation_index => 'CA2CFA8A23'
        )
    ]
}

1;
