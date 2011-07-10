package Plync::WBXML;

use strict;
use warnings;

use constant DEBUG => $ENV{PLYNC_WBXML_DEBUG};

use Try::Tiny;

use Plync::HTTPException;
use Plync::WBXML::Builder;
use Plync::WBXML::Parser;
use Plync::WBXML::Schema::ActiveSync;

sub new {
    my $class = shift;

    my $self = {@_};
    bless $self, $class;

    return $self;
}

sub parse {
    my $self = shift;
    my ($wbxml) = @_;

    return try {
        my $parser =
          Plync::WBXML::Parser->new(
            schema => Plync::WBXML::Schema::ActiveSync->schema);

        $parser->parse($wbxml);

        if (DEBUG) {
            warn '>' x 20;
            warn $parser->dom->toString(2);
            warn '>' x 20;
        }

        $parser->dom;
    }
    catch {
        Plync::HTTPException->throw(400, message => 'Malformed WBXML');
    };
}

sub build {
    my $self = shift;
    my ($dom) = @_;

    return try {
        my $builder =
          Plync::WBXML::Builder->new(
            schema => Plync::WBXML::Schema::ActiveSync->schema);
        $builder->build($dom);

        if (DEBUG) {
            warn '<' x 20;
            warn $dom->toString(2);
            warn '<' x 20;
        }

        $builder->to_wbxml;
    }
    catch {
        warn $_;
        Plync::HTTPException->throw(500);
    };
}

1;
