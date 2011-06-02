use strict;
use warnings;

use Test::More tests => 2;

use XML::LibXML;

use_ok('Plync::Command::FolderSync::Request');

#my $xml = <<'EOF';
#<?xml version="1.0" encoding="UTF-8"?>
#<FolderSync xmlns="FolderHierarchy:"><SyncKey>0</SyncKey></FolderSync>
#EOF
#
#my $req = Plync::Command::FolderSync::Request->parse($xml);
#
#is($req->sync_key, 0);

my $dom = XML::LibXML::Document->new;
$dom->setEncoding('UTF-8');
my $element = $dom->createElementNS("FolderHierarchy:", 'FolderSync');
$element->addNewChild('FolderHierarchy:', 'SyncKey')->appendText('0');
$dom->setDocumentElement($element);

#is($dom->toString, $xml);
warn $dom->toString;

my $req = Plync::Command::FolderSync::Request->parse($dom);

is($req->sync_key, 0);
