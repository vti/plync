package Plync::Command::Ping;

use strict;
use warnings;

use base 'Plync::Command::Base';

use AnyEvent;

use Plync::Storage;

sub _dispatch {
    my $self = shift;

    if (my $error = $self->req->error) {
        return $self->_dispatch_error($error);
    }

    sub {
        my $done = shift;

        # Cached Ping
        if ($self->req->is_empty) {
            return Plync::Storage->load(
                $self->_build_id => sub {
                    my $storage = shift;
                    my ($ping) = @_;

                    if (!defined $ping) {
                        $self->res->status(3);
                        return $done->();
                    }

                    # Restore Ping
                    $self->req->interval($ping->{interval});
                    $self->req->folders($ping->{folders});

                    return $self->_dispatch_watcher($done);
                }
            );
        }

        return $self->_dispatch_watcher($done);
      }
}

sub _build_id {
    my $self = shift;

    return $self->device->id . ':Ping';
}

sub _dispatch_watcher {
    my $self = shift;
    my ($done) = @_;

    Plync::Storage->save(
        $self->_build_id => {
            interval => $self->req->interval,
            folders  => $self->req->folders
          } => sub {
            $self->_setup_timer($done);

            $self->_setup_watcher($done);
        }
    );
}

sub _setup_timer {
    my $self = shift;
    my ($done) = @_;

    $self->{timer} = $self->_build_timeout(
        $self->req->interval => sub {
            delete $self->{watcher};
            $done->();
        }
    );
}

sub _setup_watcher {
    my $self = shift;
    my ($done) = @_;

    # TODO check if folders exist

    $self->{watcher} = $self->device->watch(
        $self->req->folders => sub {
            my $device = shift;
            my ($folders) = @_;

            delete $self->{timer};

            $self->res->status(2);

            foreach my $id (@$folders) {
                $self->res->add_folder($id);
            }

            $done->();
        }
    );
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
