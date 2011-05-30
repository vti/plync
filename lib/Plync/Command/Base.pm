package Plync::Command::Base;

use strict;
use warnings;

use Class::Load;
use Try::Tiny;

sub _new {
    my $class = shift;

    my $self = {@_};
    bless $self, $class;

    return $self;
}

sub req { shift->{req} }

sub dispatch {
    my $class = shift;
    my ($dom) = @_;

    my $req_class = "$class\::Request";

    Class::Load::load_class($req_class);

    my $req = try { $req_class->parse($dom) };
    return unless defined $req;

    return $class->_new(req => $req)->_dispatch;
}

1;
