package Plync::Dispatcher::WBXML;

use strict;
use warnings;

use base 'Plync::Dispatcher';

use Plync::WBXML::Parser;
use Plync::WBXML::Builder;
use Plync::WBXML::Schema::ActiveSync;
use Try::Tiny;

sub dispatch {
    my $class = shift;
    my ($wbxml) = @_;

    my $dom = $class->_parse($wbxml);
    return $class->_dispatch_error(400, 'Malformed wbxml')
      unless defined $dom;

    my $res = $class->SUPER::dispatch($dom);
    return $res if ref $res eq 'ARRAY';

    $wbxml = $class->_build($res);
    return $class->_dispatch_error(500, 'Internal Server Error')
      unless defined $wbxml;

    return $wbxml;
}

sub _parse {
    my $self = shift;
    my ($wbxml) = @_;

    return try {
        my $parser =
          Plync::WBXML::Parser->new(
            schema => Plync::WBXML::Schema::ActiveSync->schema);

        $parser->parse($wbxml);

        $parser->dom;
    };
}

sub _build {
    my $self = shift;
    my ($dom) = @_;

    return try {
        my $builder =
          Plync::WBXML::Builder->new(
            schema => Plync::WBXML::Schema::ActiveSync->schema);
        $builder->build($dom);

        $builder->to_wbxml;
    };
}

1;
