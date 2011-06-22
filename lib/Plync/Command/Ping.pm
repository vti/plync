package Plync::Command::Ping;

use strict;
use warnings;

use base 'Plync::Command::Base';

use AnyEvent;

sub _dispatch {
    my $self = shift;

    if (my $error = $self->req->error) {
        return $self->_dispatch_error($error);
    }

    sub {
        my $done = shift;

        my $interval = $self->req->interval;
        my $folders  = $self->req->folders;

        # TODO check if folders exist

        my $res = $self->res;

        $self->{timer} = $self->_build_timeout(
            $self->req->interval => sub {
                $self->device->stop_watch_folders(
                    $folders => sub { $done->() });
            }
        );

        $self->device->start_watch_folders(
            $folders => sub {
                my $device = shift;
                my ($folders) = @_;

                delete $self->{timer};

                $res->status(2);

                foreach my $id (@$folders) {
                    $res->add_folder($id);
                }

                $done->();
            }
        );
    }
}

sub _dispatch_error {
    my $self = shift;
    my ($error) = @_;

    $self->res->status($error);

    if ($error == 5) {
        $self->res->interval($self->req->interval);
    }
    elsif ($error == 6) {
        $self->res->max_folders($self->req->max_folders);
    }
}

sub _build_timeout {
    my $self = shift;
    my ($interval, $cb) = @_;

    return AnyEvent->timer(after => $interval, cb => $cb);
}

1;
