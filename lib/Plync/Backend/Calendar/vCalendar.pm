package Plync::Backend::Calendar::vCalendar;

use strict;
use warnings;

use base 'Plync::Backend::Base';

use AnyEvent;
use AnyEvent::AIO;
use IO::AIO;
use Linux::Inotify2; # TODO other watchers on other platforms

use Plync::Backend::Calendar::vCalendar::Parser;

sub new {
    my $self = shift->SUPER::new(@_);

    die "Missing 'path' param" unless $self->{path};

    $self->{path} = $self->_resolv_path($self->{path});

    $self->{events} ||= [];

    $self->{id} = 'vcalendar';

    return $self;
}

sub fetch_folders {
    my $self = shift;
    my ($cb) = @_;

    my $folder_set = $self->_build_folder_set;
    $folder_set->add($self->_build_folder);

    $cb->($self, $folder_set);
}

sub fetch_folder {
    my $self = shift;
    my ($id, $cb) = @_;

    return $cb->($self) unless $id eq $self->{id};

    $self->_events(
        sub {
            my $self = shift;
            my ($events) = @_;

            my $folder = $self->_build_folder;

            foreach my $event (@$events) {
                $folder->add_item($event);
            }

            $cb->($self, $folder);
        }
    );
}

sub fetch_item {
    my $self = shift;
    my ($folder, $item_id, $cb) = @_;

    $self->_events(
        sub {
            my $self = shift;
            my ($events) = @_;

            foreach my $event (@$events) {
                if ($event->{id} eq $item_id) {
                    return $cb->($self, $event);
                }
            }

            return $cb->($self);
        }
    );
}

sub watch {
    my $self = shift;
    my ($folders, $cb) = @_;

    return $self->_build_watcher(
        on_start => sub {
            my $watcher = shift;

            my $inotify = Linux::Inotify2->new
              or die "unable to create new inotify object: $!";

            $watcher->{inotify_watcher} = $inotify->watch(
                $self->{path}, IN_MODIFY, sub {
                    my $e = shift;

                    $e->w->cancel;

                    delete $watcher->{ae_watcher};
                    delete $watcher->{inotify};
                    delete $watcher->{inotify_watcher};

                    $cb->($self, [$self->{id}]);
                }
            ) or die $!;

            $watcher->{ae_watcher} = AnyEvent->io(
                fh   => $inotify->fileno,
                poll => 'r',
                cb   => sub { $inotify->poll }
            );

            $watcher->{inotify} = $inotify;
        },
        on_destroy => sub {
            my $watcher = shift;

            delete $watcher->{ae_watcher};
            delete $watcher->{inotify};
            delete $watcher->{inotify_watcher};
        }
    );
}

sub _resolv_path {
    my $self = shift;
    my ($path) = @_;

    # TODO %u

    return $path;
}

sub _events {
    my $self = shift;
    my ($cb) = @_;

    my $last_mtime = $self->{mtime} || 0;

    $self->_mtime(
        $self->{path} => sub {
            my $self = shift;
            my ($mtime) = @_;

            if ($mtime > $last_mtime) {
                return $self->_slurp(
                    $self->{path} => sub {
                        my $self = shift;
                        my ($contents) = @_;

                        my $events = $self->_parse($contents);

                        $self->{mtime}  = $mtime;
                        $self->{events} = $events;

                        return $cb->($self, $events);
                    }
                );
            }

            return $cb->($self, $self->{events});
        }
    );
}

sub _mtime {
    my $self = shift;
    my ($path, $cb) = @_;

    aio_stat $path, sub {
        my $status and die "Stat failed: $!";

        $cb->($self, (stat(_))[9]);
    };
}

sub _slurp {
    my $self = shift;
    my ($path, $cb) = @_;

    aio_open $path, IO::AIO::O_RDONLY, 0, sub {
        my $fh = shift or die "error while opening: $!";

        # This is nonblocking
        my $size = -s $fh;

        my $contents = '';
        aio_read $fh, 0, $size, $contents, 0, sub {
            $_[0] == $size or die "short read: $!";

            close $fh;

            $cb->($self, $contents);
        };
    };
}

sub _parse {
    my $self = shift;
    my ($string) = @_;

    return Plync::Backend::Calendar::vCalendar::Parser->parse($string);
}

sub _build_folder {
    my $self = shift;

    return $self->SUPER::_build_folder(
        id           => $self->{id},
        class        => 'Calendar',
        display_name => 'Calendar'
    );
}

1;
