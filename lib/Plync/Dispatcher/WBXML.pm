package Plync::Dispatcher::WBXML;

use strict;
use warnings;

use base 'Plync::Dispatcher';

use Plync::WBXML;
use Try::Tiny;

sub dispatch {
    my $class = shift;
    my ($wbxml) = @_;

    my $xml = try { Plync::WBXML->wbxml2xml($wbxml) };
    return $class->_dispatch_error(400, 'Malformed wbxml')
      unless defined $xml;

    $xml = $class->SUPER::dispatch($xml);
    return $xml if ref $xml eq 'ARRAY';

    $wbxml = try { Plync::WBXML->xml2wbxml($xml) };
    return $class->_dispatch_error(500, 'Internal Server Error')
      unless defined $wbxml;

    return $wbxml;
}

1;
