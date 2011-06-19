package Plync::User;

use strict;
use warnings;

use Digest::MD5 ();

sub new {
    my $class = shift;

    my $self = {@_};
    bless $self, $class;

    if (defined $self->{password}) {
        $self->{password} = Digest::MD5::md5_hex($self->{password});
    }

    return $self;
}

sub id {
    my $self = shift;

    return join ':', 'user', $self->{username};
}

sub username { $_[0]->{username} }
sub password { $_[0]->{password} }

sub check_password {
    my $self = shift;
    my ($password) = @_;

    return Digest::MD5::md5_hex($password) eq $self->{password};
}

1;
