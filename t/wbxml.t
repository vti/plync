use strict;
use warnings;

use Test::More tests => 1;

use Plync::WBXML;

my $data = pack 'H*' => '03016A00455C4F5003436F6E746163747300014B0332000152033200014E0331000156474D03323A3100015D00114A46033100014C033000014D033100010100015E0348616C6C2C20446F6E00015F03446F6E0001690348616C6C000100115603310001010101010101';

my $xml = q{<?xml version='1.0' encoding='UTF-8'?><Sync><Collections><Collection><Class>Contacts</Class><SyncKey>2</SyncKey><CollectionId>2</CollectionId><Status>1</Status><Commands><Add><ServerId>2:1</ServerId><ApplicationData><Body><Type>1</Type><EstimatedDataSize>0</EstimatedDataSize><Truncated>1</Truncated></Body><FileAs>Hall, Don</FileAs><FirstName>Don</FirstName><LastName>Hall</LastName><NativeBodyType>1</NativeBodyType></ApplicationData></Add></Commands></Collection></Collections></Sync>};

is(Plync::WBXML->wbxml2xml($data), $xml);
