package Plync::WBXML;

use strict;
use warnings;

use WAP::SAXDriver::wbxml;
use WAP::wbxml;
use XML::DOM;
use XML::SAX::Writer;

sub xml2wbxml {
    my $class = shift;
    my ($xml) = @_;

    my $rules = WAP::wbxml::WbRules::Load($class->_path_to_schema);
    my $wbxml = WAP::wbxml->new($rules);

    my $parser  = XML::DOM::Parser->new;
    my $doc_xml = $parser->parse($xml);

    return $wbxml->compile($doc_xml, 'UTF-8');
}

sub wbxml2xml {
    my $class = shift;
    my ($wbxml) = @_;

    my $consumer = XML::SAX::Writer::StringConsumer->new;
    my $handler = XML::SAX::Writer->new(Output => $consumer);
    my $parser = WAP::SAXDriver::wbxml->new(
        Handler      => $handler,
        RulesPath    => $class->_path_to_rules
    );

    my $doc = $parser->parse(Source => {String => $wbxml});
    return ${$consumer->finalize};
}

sub _path_to_schema {
    my $class = shift;

    my $inc = $INC{'WAP/wbxml.pm'};
    $inc =~ s/\.pm$//;

    my $path = "$inc/activesync.wbrules.xml";

    die "Can't open schema: $path: $!" unless -f $path;

    return $path;
}

sub _path_to_rules {
    my $class = shift;

    my $inc = $INC{'WAP/SAXDriver/wbxml.pm'};
    $inc =~ s/\.pm$//;

    my $path = "$inc/activesync.wbrules2.pl";

    die "Can't open rules: $path: $!" unless -f $path;

    return $path;
}

1;
