package Plync::Dispatcher::WBXML;

use strict;
use warnings;

use base 'Plync::Dispatcher';

use Plync::HTTPException;
use Plync::WBXML::Parser;
use Plync::WBXML::Builder;
use Plync::WBXML::Schema::ActiveSync;

use Try::Tiny;

sub dispatch {
    my $class = shift;
    my ($wbxml) = @_;

    my $dom = $class->_parse($wbxml);

    my $res = $class->SUPER::dispatch($dom);

    return $class->_build($res);
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
    }
    catch {
        Plync::HTTPException->throw(400, message => 'Malformed WBXML');
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
    }
    catch {
        Plync::HTTPException->throw(500);
    };
}

1;
