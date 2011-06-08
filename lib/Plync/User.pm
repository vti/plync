package Plync::User;

use strict;
use warnings;

sub new {
    my $class = shift;

    my $self = {@_};
    bless $self, $class;

    return $self;
}

sub load {
    my $class = shift;
    my ($username) = @_;

    return unless $username eq 'foo';

    return $class->new(username => 'foo');
}

sub check_password {
    my $self = shift;
    my ($password) = @_;

    return $password eq 'bar';
}

sub authenticate {
    my $class = shift;
    my ($username, $password) = @_;

    my $user = $class->load($username);
    return unless $user;

    return $user->check_password($password);
}

1;
