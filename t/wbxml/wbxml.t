use strict;
use warnings;

use lib '/home/vti/dev/wap-wbxml/lib';

use Test::More tests => 1;

use Data::HexDump;
use Plync::WBXML;

my $data = pack 'H*' => '03016a00455c4f5003436f6e746163747300014b0332000152033200014e0331000156474d03323a3100015d00114a46033100014c033000014d033100010100015e0348616c6c2c20446f6e00015f03446f6e0001690348616c6c000100115603310001010101010101';

my $xml = <<'EOF';
<?xml version="1.0" encoding="UTF-8"?>
<Sync><Collections><Collection><Class>Contacts</Class><SyncKey>2</SyncKey><CollectionId>2</CollectionId><Status>1</Status><Commands><Add><ServerId>2:1</ServerId><ApplicationData><Body><Type>1</Type><EstimatedDataSize>0</EstimatedDataSize><Truncated>1</Truncated></Body><FileAs>Hall, Don</FileAs><FirstName>Don</FirstName><LastName>Hall</LastName><NativeBodyType>1</NativeBodyType></ApplicationData></Add></Commands></Collection></Collections></Sync>
EOF

#warn "\n" . HexDump($data);
#warn "\n" . HexDump(Plync::WBXML->xml2wbxml($xml));

is(Plync::WBXML->wbxml2xml($data), $xml);
#warn unpack('H*', Plync::WBXML->xml2wbxml($xml));
#is(Plync::WBXML->xml2wbxml($xml), $data);
