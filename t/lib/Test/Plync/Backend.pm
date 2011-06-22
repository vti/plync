package Test::Plync::Backend;

use strict;
use warnings;

use base 'Plync::Backend::Base';

use Plync::Email;
use Plync::Folder;
use Plync::FolderSet;

sub fetch_folders {
    my $self = shift;
    my ($cb) = @_;

    my $folder_set = Plync::FolderSet->new;
    $folder_set->add(
        Plync::Folder->new(
            id           => 1,
            class        => 'Email',
            type         => 'Inbox',
            display_name => 'Inbox'
        )
    );

    $cb->($self, $folder_set);
}

sub fetch_folder {
    my $self = shift;
    my ($folder, $cb) = @_;

    $folder->add_item(
        Plync::Email->new(
            id                 => 1,
            to                 => '"Device User" <deviceuser@example.com>',
            from               => '"Device User 2" <deviceuser2@example.com>',
            subject            => 'New mail message',
            date_received      => '2009-07-29T19:25:37.817Z',
            internet_CPID      => '1252',
            conversation_id    => 'FF68022058BD485996BE15F6F6D99320',
            conversation_index => 'CA2CFA8A23'
        )
    );

    $cb->($self, $folder);
}

sub fetch_folder_item {
    my $self = shift;
    my ($folder, $item_id, $cb) = @_;

    my $item;

    if ($item_id == 1) {
        $item = Plync::Email->new(
            id            => 1,
            to            => '"Device User" <deviceuser@example.com>',
            from          => '"Device User 2" <deviceuser2@example.com>',
            subject       => 'New mail message',
            date_received => '2009-07-29T19:25:37.817Z',
            internet_CPID      => '1252',
            conversation_id    => 'FF68022058BD485996BE15F6F6D99320',
            conversation_index => 'CA2CFA8A23'
        );
    }

    $cb->($self, $item);
}

1;
