package Schema1;

use base 'Plync::WBXML::Schema::Base';

our $CODES = {0x00 => {0x05 => 'BR', 0x06 => 'CARD', 0x07 => 'XYZ'}};

package Schema2;

use base 'Plync::WBXML::Schema::Base';

our $CODES =
  {0x00 => {0x05 => 'CARD', 0x06 => 'INPUT', 0x07 => 'XYZ', 0x08 => 'DO'}};

our $ATTR_NAMES = {
    0x00 => {
        0x05 => 'STYLE=LIST',
        0x06 => 'TYPE',
        0x07 => 'TYPE=TEXT',
        0x08 => 'URL=http://',
        0x09 => 'NAME',
        0x0a => 'KEY'
    }
};

our $ATTR_VALUES = {0x00 => {0x85 => '.org', 0x86 => 'ACCEPT'}};

use strict;
use warnings;

use Test::More tests => 12;

use_ok('Plync::WBXML::Parser');

use Plync::WBXML::Schema::ActiveSync;

my $data = pack 'H*', =>
  '03010300474603205820262059000503205800028120033d00028120033120000101';

my $parser = Plync::WBXML::Parser->new(schema => Schema1->schema);

ok($parser->parse($data));
is($parser->version,  3);
is($parser->publicid, 1);
is($parser->charset,  'ANSI_X3.4-1968');
isa_ok($parser->dom, 'XML::LibXML::Document');
is($parser->to_string, <<'EOF');
<?xml version="1.0" encoding="ANSI_X3.4-1968"?>
<XYZ><CARD> X &amp; Y<BR/> X&nbsp;=&nbsp;1 </CARD></XYZ>
EOF

$data = pack 'H*' =>
  '03016A126162630020456e746572206e616d653a200047C50983000501880686080378797a0085032f730001830486070A034e00010101';

$parser = Plync::WBXML::Parser->new(schema => Schema2->schema);

ok($parser->parse($data));
is($parser->version,  3);
is($parser->publicid, 1);
is($parser->charset,  "UTF-8");
is($parser->to_string, <<'EOF');
<?xml version="1.0" encoding="UTF-8"?>
<XYZ><CARD NAME="abc" STYLE="LIST"><DO TYPE="ACCEPT" URL="http://xyz.org/s"/> Enter name: <INPUT TYPE="TEXT" KEY="N"/></CARD></XYZ>
EOF
