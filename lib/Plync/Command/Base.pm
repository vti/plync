package Plync::Command::Base;

use strict;
use warnings;

use Plync::HTTPException;
use Class::Load;
use Try::Tiny;

sub new {
    my $class = shift;

    my $self = {@_};
    bless $self, $class;

    return $self;
}

sub req { @_ > 1 ? $_[0]->{req} = $_[1] : $_[0]->{req} }

sub res {
    my $self = shift;

    $self->{res} ||= $self->req->new_response;

    return $self->{res};
}

sub dispatch {
    my $self = shift;
    my ($dom) = @_;

    my $class = ref $self;

    my $req_class = "$class\::Request";

    Class::Load::load_class($req_class);

    my $req = try {
        $req_class->parse($dom);
    }
    catch {
        Plync::HTTPException->throw(500);
    };

    $self->req($req);

    $self->_dispatch;

    return $self->res->dom;
}

1;
