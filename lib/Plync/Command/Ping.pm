package Plync::Command::Ping;

use strict;
use warnings;

use base 'Plync::Command::Base';

sub _dispatch {
    my $self = shift;

    use Data::Dumper;
    warn Dumper $self->req;

    return $self->req->new_response;
}

1;
