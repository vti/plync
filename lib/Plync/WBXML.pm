package Plync::WBXML;

use strict;
use warnings;

use Plync::WBXML::Parser;
use Plync::WBXML::Schema::ActiveSync;

#sub xml2wbxml {
#    my $class = shift;
#    my ($xml) = @_;
#
#    my $rules = WAP::wbxml::WbRules::Load($class->_path_to_schema);
#    my $wbxml = WAP::wbxml->new($rules);
#
#    my $parser  = XML::DOM::Parser->new;
#    my $doc_xml = $parser->parse($xml);
#
#    return $wbxml->compile($doc_xml, 'UTF-8');
#}

sub wbxml2xml {
    my $class = shift;
    my ($wbxml) = @_;

    my $parser = Plync::WBXML::Parser->new(schema => Plync::WBXML::Schema::ActiveSync->schema);

    $parser->parse($wbxml);

    return $parser->to_string;
}

1;
