package Plync::UserManager;

use strict;
use warnings;

sub new {
    my $class = shift;

    my $self = {@_};
    bless $self, $class;

    die "Missing 'storage' param" unless $self->{storage};

    return $self;
}

sub authorize {
    my $self = shift;
    my ($username, $password, $ok_cb, $error_cb) = @_;

    $self->{storage}->load(
        "user:$username" => sub {
            my $user = $_[1];

            return $error_cb->($self)
              unless $user && $user->check_password($password);

            return $ok_cb->($self, $user);
        }
    );
}

1;
