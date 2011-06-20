package Plync::Storage::Memory;

use strict;
use warnings;

use base 'Plync::Storage::Base';

sub new {
    my $self = shift->SUPER::new(@_);

    $self->{memory} = {};

    return $self;
}

sub load {
    my $self = shift;
    my ($id, $cb) = @_;

    $cb->($self, $self->{memory}->{$id});
}

sub save {
    my $self = shift;
    my ($id, $object, $cb) = @_;

    $self->{memory}->{$id} = $object;

    $cb->($self);
}

sub delete {
    my $self = shift;
    my ($id, $cb) = @_;

    delete $self->{memory}->{$id};

    $cb->($self);
}

1;
