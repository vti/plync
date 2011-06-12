package Plync::User;

use strict;
use warnings;

use base 'Plync::Storable';

use Digest::MD5 ();

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

sub save {
    my $self = shift;

    die "Required 'username'" unless defined $self->{username};
    die "Required 'password'" unless defined $self->{password};

    $self->{password} = Digest::MD5::md5_hex($self->{password});

    return $self->SUPER::save(@_);
}

1;
