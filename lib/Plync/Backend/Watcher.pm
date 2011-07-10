package Plync::Backend::Watcher;

use strict;
use warnings;

sub new {
    my $class = shift;

    my $self = {@_};
    bless $self, $class;

    $self->_start;

    return $self;
}

sub _start {
    my $self = shift;

    $self->{on_start}->($self);
}

sub _destroy {
    my $self = shift;

    $self->{on_destroy}->($self);
}

sub DESTROY {
    $_[0]->_destroy;
}

1;
