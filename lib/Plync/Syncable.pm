package Plync::Syncable;

use strict;
use warnings;

use Scalar::Util qw(blessed);

sub new {
    my $class = shift;

    my $self = {@_};
    bless $self, $class;

    $self->{sync_key} = 0;

    return $self;
}

sub reset {
    my $self = shift;

    $self->{sync_key} = 0;

    return $self->{sync_key};
}

sub synced {
    my $self = shift;

    $self->{sync_key} = $self->_generate_key;

    return $self;
}

sub sync_key { @_ > 1 ? $_[0]->{sync_key} = $_[1] : $_[0]->{sync_key} }

sub _generate_key {
    my $self = shift;

    if (my $generator = $self->{sync_key_generator}) {
        return blessed $generator ? $generator->generate : $generator->($self);
    }

    my $key = '';

    my @set = (0 .. 9, 'a' .. 'z', 'A' .. 'Z');

    for (1 .. 12) {
        $key .= $set[int(rand(scalar @set))];
    }

    return $key;
}

1;
