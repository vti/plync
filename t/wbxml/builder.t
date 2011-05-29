use strict;
use warnings;

use Test::More tests => 2;

use_ok('Plync::WBXML::Builder');

use Plync::WBXML::Schema::ActiveSync;

#my $data = pack 'H*', =>
#  '03010300474603205820262059000503205800028120033d00028120033120000101';
#
#my $builder = Plync::WBXML::Builder->new(
#    charset  => 'ASCII',
#    publicid => 1,
#    version  => 3,
#    tags     => {
#        'BR'   => 0x05,
#        'CARD' => 0x06,
#        'XYZ'  => 0x07
#    }
#);
#
#my $xml = <<'EOF';
#<?xml version="1.0"?>
#<!DOCTYPE XYZ [
#    <!ELEMENT XYZ (CARD)+>
#    <!ELEMENT CARD (#PCDATA | BR)*>
#    <!ELEMENT BR EMPTY>
#    <!ENTITY nbsp "&#160;">
#    ]>
#<XYZ><CARD> X &amp; Y<BR/> X&nbsp;=&nbsp;1 </CARD></XYZ>
#EOF
#$builder->build($xml);
#is($builder->to_wbxml, $data);
#
#$data = pack 'H*' =>
#  '03016A126162630020456e746572206e616d653a200047C50983000501880686080378797a0085032f730001830486070A034e00010101';
#
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

my $builder =
  Plync::WBXML::Builder->new(
    schema => Plync::WBXML::Schema::ActiveSync->schema);

$builder->build(<<'EOF');
<?xml version="1.0" encoding="utf-8"?>
<Sync xmlns="AirSync:" xmlns:airsyncbase="AirSyncBase:" xmlns:contacts="Contacts:">
    <Collections>
        <Collection>
            <Class>Contacts</Class>
            <SyncKey>2</SyncKey>
            <CollectionId>2</CollectionId>
            <Status>1</Status>
            <Commands>
                <Add>
                    <ServerId>2:1</ServerId>
                    <ApplicationData>
                        <airsyncbase:Body>
                            <airsyncbase:Type>1</airsyncbase:Type>
                            <airsyncbase:EstimatedDataSize>0</airsyncbase:EstimatedDataSize>
                            <airsyncbase:Truncated>1</airsyncbase:Truncated>
                        </airsyncbase:Body>
                        <contacts:FileAs>Hall, Don</contacts:FileAs>
                        <contacts:FirstName>Don</contacts:FirstName>
                        <contacts:LastName>Hall</contacts:LastName>
                        <airsyncbase:NativeBodyType>1</airsyncbase:NativeBodyType>
                    </ApplicationData>
                </Add>
            </Commands>
        </Collection>
    </Collections>
</Sync>
EOF

is($builder->to_wbxml,
    pack('H*',
        '03016a00455c4f5003436f6e746163747300014b0332000152033200014e0331000156474d03323a3100015d00114a46033100014c033000014d033100010100015e0348616c6c2c20446f6e00015f03446f6e0001690348616c6c000100115603310001010101010101'));
