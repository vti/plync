package PlyncBackendvCalendarTest;

use strict;
use warnings;

use base 'Test::Class';

use Test::Plync;
use AnyEvent;

use Plync::Backend::Calendar::vCalendar;

sub make_fixture : Test(setup) {
    my $self = shift;

}

sub test_fetch_folders : Test(2) {
    my $self = shift;

    my $backend = $self->_build_backend;

    $backend->fetch_folders(
        sub {
            my $backend = shift;
            my ($set) = @_;

            is scalar @{$set->list}, 1;
            is $set->list->[0]->display_name, 'Calendar';
        }
    );
}

sub test_fetch_folder : Test(2) {
    my $self = shift;

    my $items;

    my $cv = AnyEvent->condvar;

    my $backend = $self->_build_backend;

    $cv->begin;
    $backend->fetch_folder(
        'vcalendar' => sub {
            my $backend = shift;
            my ($folder) = @_;

            $items = $folder->items;

            $cv->end;
        }
    );

    $cv->wait;
    is scalar @$items, 1;

    $cv->begin;
    $backend->fetch_folder(
        'vcalendar' => sub {
            my $backend = shift;
            my ($folder) = @_;

            $items = $folder->items;

            $cv->end;
        }
    );

    $cv->wait;
    is scalar @$items, 1;
}

sub test_fetch_item : Test(1) {
    my $self = shift;

    my $item;

    my $cv = AnyEvent->condvar;

    my $backend = $self->_build_backend;

    $cv->begin;
    $backend->fetch_item(
        undef, 'foo@bar.com' => sub {
            my $backend = shift;

            $item = shift;

            $cv->end;
        }
    );

    $cv->wait;
    ok $item;
}

#sub test_watcher : Test(1) {
#    my $self = shift;
#
#    my $cv = AnyEvent->condvar;
#
#    my $backend = $self->_build_backend;
#
#    my $changed = 0;
#
#    $cv->begin;
#    my $w = $backend->watch(
#        undef => sub {
#            my $backend = shift;
#
#            $changed = 1;
#
#            $cv->end;
#        }
#    );
#
#    $w->start;
#
#    open my $fh, '>>', 't/backend/vcalendar/calendar.ics';
#    print $fh time . "\n";
#    close $fh;
#
#    $cv->wait;
#
#    ok $changed;
#}

sub _build_backend {
    my $self = shift;

    return Plync::Backend::Calendar::vCalendar->new(
        path => 't/backend/vcalendar/calendar.ics',
        @_
    );
}

1;
