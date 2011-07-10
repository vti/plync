package Plync::UserManager;

use strict;
use warnings;

use Plync::Storage;

sub new {
    my $class = shift;

    my $self = {@_};
    bless $self, $class;

    return $self;
}

sub authorize {
    my $self = shift;
    my ($username, $password, $ok_cb, $error_cb) = @_;

    Plync::Storage->load(
        "user:$username" => sub {
            my $user = $_[1];

            return $error_cb->($self)
              unless $user && $user->check_password($password);

            return $ok_cb->($self, $user);
        }
    );
}

1;
