package Test::Plync::Backend;

use strict;
use warnings;

use base 'Plync::Backend::Base';

use Plync::Email;
use Plync::Event;
use Plync::Folder;
use Plync::FolderSet;

sub fetch_folders {
    my $self = shift;
    my ($cb) = @_;

    my $folder_set = Plync::FolderSet->new;
    $folder_set->add(
        Plync::Folder->new(
            id           => 'root',
            class        => 'Email',
            type         => 'Inbox',
            display_name => 'Inbox'
        )
    );
    $folder_set->add(
        Plync::Folder->new(
            id           => 'root_calendar',
            class        => 'Calendar',
            display_name => 'Calendar'
        )
    );

    $cb->($self, $folder_set);
}

sub fetch_folder {
    my $self = shift;
    my ($id, $cb) = @_;

    my $folder;

    if ($id eq 'root') {
        $folder = Plync::Folder->new(
            id           => $id,
            class        => 'Email',
            type         => 'Inbox',
            display_name => 'Inbox'
        );
        $folder->add_item(
            Plync::Email->new(
                id                 => 321,
                to                 => '"Device User" <deviceuser@example.com>',
                from               => '"Device User 2" <deviceuser2@example.com>',
                subject            => 'New mail message',
                date_received      => '2009-07-29T19:25:37.817Z',
                internet_CPID      => '1252',
                conversation_id    => 'FF68022058BD485996BE15F6F6D99320',
                conversation_index => 'CA2CFA8A23'
            )
        );
    }
    elsif ($id eq 'root_calendar') {
        $folder = Plync::Folder->new(
            id           => $id,
            class        => 'Calendar',
            display_name => 'Inbox'
        );
        $folder->add_item(
            Plync::Event->new(
                id => 123,
                subject    => 'Foo bar baz!',
                start_time => '20110630T101000Z',
                end_time   => '20110630T202000Z'
            )
        );
    }

    $cb->($self, $folder);
}

sub fetch_item {
    my $self = shift;
    my ($folder, $item_id, $cb) = @_;

    my $item;

    if ($folder->class eq 'Email') {
        $item = Plync::Email->new(
            id            => 1,
            to            => '"Device User" <deviceuser@example.com>',
            from          => '"Device User 2" <deviceuser2@example.com>',
            subject       => 'New mail message',
            thread_topic       => 'New mail message',
            date_received => '2009-07-29T19:25:37.817Z',
            internet_CPID      => '1252',
            conversation_id    => 'FF68022058BD485996BE15F6F6D99320',
            conversation_index => 'CA2CFA8A23',
            body => {
                type => 2,
                data => 'Hello there!'
            }
        );
    }
    elsif ($folder->class eq 'Calendar') {
        $item = Plync::Event->new(
            id => 123,
            subject    => 'Foo bar baz!',
            start_time => '20110630T000000Z',
            end_time   => '20110633T000000Z'
        );
    }

    $cb->($self, $item);
}

sub watch {
    my $self = shift;
    my ($folders, $cb) = @_;

    return Test::Plync::Backend::Watcher->new(
        folders  => $folders,
        on_event => $cb
    )->start;
}

package Test::Plync::Backend::Watcher;

use strict;
use warnings;

sub new {
    my $class = shift;

    my $self = {@_};
    bless $self, $class;

    return $self;
}

sub start {
    my $self = shift;

    my $folders = $self->{folders};

    if ($folders->[0]->{id} eq 'root_calendar') {
        $self->{on_event}->($self, [$folders->[0]->{id}]);
    }
}

1;
