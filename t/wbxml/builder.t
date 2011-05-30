package Schema1;

use base 'Plync::WBXML::Schema::Base';

our $TAGS = {'' => {'BR' => 0x05, 'CARD' => 0x06, 'XYZ' => 0x07}};

package Schema2;

use base 'Plync::WBXML::Schema::Base';

our $TAGS = {'BR' => 0x05, 'CARD' => 0x06, 'XYZ' => 0x07};

use strict;
use warnings;

use Test::More tests => 3;

use_ok('Plync::WBXML::Builder');

my $data = pack 'H*', =>
  '03010300474603205820262059000503205800028120033d00028120033120000101';

my $builder = Plync::WBXML::Builder->new(
    charset  => 'ASCII',
    publicid => 1,
    version  => 3,
    schema   => Schema1->schema
);

my $xml = <<'EOF';
<?xml version="1.0"?>
<!DOCTYPE XYZ [
    <!ELEMENT XYZ (CARD)+>
    <!ELEMENT CARD (#PCDATA | BR)*>
    <!ELEMENT BR EMPTY>
    <!ENTITY nbsp "&#160;">
    ]>
<XYZ><CARD> X &amp; Y<BR/> X&nbsp;=&nbsp;1 </CARD></XYZ>
EOF
$builder->build($xml);
is($builder->to_wbxml, $data);

$builder =
  Plync::WBXML::Builder->new(charset => 'ASCII', schema => Schema1->schema);

my $xml_parser = XML::LibXML->new;
$xml_parser->set_options(no_blanks => 1);
$xml_parser->expand_entities(0);
my $dom = $xml_parser->parse_string($xml);

$builder->build($dom);
is($builder->to_wbxml, $data);

$data = pack 'H*' =>
  '03016A126162630020456e746572206e616d653a200047C50983000501880686080378797a0085032f730001830486070A034e00010101';

#$builder = Plync::WBXML::Builder->new(
#    charset  => 'UTF-8',
#    publicid => 1,
#    version  => 3,
#    tags     => {
#        'BR'   => 0x05,
#        'CARD' => 0x06,
#        'XYZ'  => 0x07
#    }
#);
#
#$xml = <<'EOF';
#<?xml version="1.0"?>
#<!DOCTYPE XYZ [
#    <!ELEMENT XYZ ( CARD )+ >
#    <!ELEMENT CARD (#PCDATA | INPUT | DO)*>
#    <!ATTLIST CARD NAME NMTOKEN #IMPLIED>
#    <!ATTLIST CARD STYLE (LIST|SET) 'LIST'>
#    <!ELEMENT DO EMPTY>
#    <!ATTLIST DO TYPE CDATA #REQUIRED>
#    <!ATTLIST DO URL CDATA #IMPLIED>
#    <!ELEMENT INPUT EMPTY>
#    <!ATTLIST INPUT TYPE (TEXT|PASSWORD) 'TEXT'>
#    <!ATTLIST INPUT KEY NMTOKEN #IMPLIED>
#    <!ENTITY nbsp "&#160;">
#    ]>
#    <!-- This is a comment -->
#<XYZ>
#    <CARD NAME="abc" STYLE="LIST">
#        <DO TYPE="ACCEPT" URL="http://xyz.org/s"/>
#        Enter name: <INPUT TYPE="TEXT" KEY="N"/>
#    </CARD>
#</XYZ>
#EOF
#warn '';
#warn unpack 'H*', $data;
#$builder->build($xml);
#warn unpack 'H*', $builder->to_wbxml;
#is($builder->to_wbxml, $data);
