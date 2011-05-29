use strict;
use warnings;

use Test::More tests => 19;

use_ok('Plync::WBXML::Parser');

use Plync::WBXML::Schema::ActiveSync;

my $data = pack 'H*', =>
  '03010300474603205820262059000503205800028120033d00028120033120000101';

my $parser =
  Plync::WBXML::Parser->new(schema =>
      {tags => {0x00 => {0x05 => 'BR', 0x06 => 'CARD', 0x07 => 'XYZ'}}});

ok($parser->parse($data));
is($parser->version,  3);
is($parser->publicid, 1);
is($parser->charset,  'ASCII');
is($parser->to_string, <<'EOF');
<?xml version="1.0" encoding='ASCII'?>
<XYZ><CARD> X &amp; Y<BR/> X&nbsp;=&nbsp;1 </CARD></XYZ>
EOF

$data = pack 'H*' =>
  '03016A126162630020456e746572206e616d653a200047C50983000501880686080378797a0085032f730001830486070A034e00010101';

$parser = Plync::WBXML::Parser->new(
    schema => {
        tags => {
            0x00 =>
              {0x05 => 'CARD', 0x06 => 'INPUT', 0x07 => 'XYZ', 0x08 => 'DO'}
        },
        attr_names => {
            0x00 => {
                0x05 => 'STYLE=LIST',
                0x06 => 'TYPE',
                0x07 => 'TYPE=TEXT',
                0x08 => 'URL=http://',
                0x09 => 'NAME',
                0x0a => 'KEY'
            }
        },
        attr_values => {
            0x00 => {
                0x85 => '.org',
                0x86 => 'ACCEPT'
            }
        }
    }
);

ok($parser->parse($data));
is($parser->version,  3);
is($parser->publicid, 1);
is($parser->charset,  "UTF-8");
is($parser->to_string, <<'EOF');
<?xml version="1.0" encoding="UTF-8"?>
<XYZ><CARD NAME="abc" STYLE="LIST"><DO TYPE="ACCEPT" URL="http://xyz.org/s"/> Enter name: <INPUT TYPE="TEXT" KEY="N"/></CARD></XYZ>
EOF

$data = pack 'H*' =>
  '03016a00455c4f5003436f6e746163747300014b0332000152033200014e0331000156474d03323a3100015d00114a46033100014c033000014d033100010100015e0348616c6c2c20446f6e00015f03446f6e0001690348616c6c000100115603310001010101010101';

$parser = Plync::WBXML::Parser->new(schema => Plync::WBXML::Schema::ActiveSync->schema);

ok($parser->parse($data));
is($parser->version,  3);
is($parser->publicid, 1);
is($parser->charset,  "UTF-8");
is($parser->to_string, <<'EOF');
<?xml version="1.0" encoding="UTF-8"?>
<Sync><Collections><Collection><Class>Contacts</Class><SyncKey>2</SyncKey><CollectionId>2</CollectionId><Status>1</Status><Commands><Add><ServerId>2:1</ServerId><ApplicationData><Body><Type>1</Type><EstimatedDataSize>0</EstimatedDataSize><Truncated>1</Truncated></Body><FileAs>Hall, Don</FileAs><FirstName>Don</FirstName><LastName>Hall</LastName><NativeBodyType>1</NativeBodyType></ApplicationData></Add></Commands></Collection></Collections></Sync>
EOF
