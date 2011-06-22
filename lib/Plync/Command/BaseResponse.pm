package Plync::Command::BaseResponse;

use strict;
use warnings;

sub new {
    my $class = shift;

    my $self = {@_};
    bless $self, $class;

    return $self;
}

sub dom {
    my $self = shift;

    $self->{dom} ||= $self->build;

    return $self->{dom};
}

sub to_string {
    my $self = shift;

    return $self->dom->toString(@_);
}

1;
