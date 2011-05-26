use strict;
use warnings;

use Test::More tests => 2;

use XML::XPath;

use_ok('Plync::Command::FolderSync::Request');

my $req = Plync::Command::FolderSync::Request->parse(<<'EOF');
<?xml version="1.0" encoding="utf-8"?>
<FolderSync xmlns="FolderHierarchy:">
<SyncKey>0</SyncKey>
</FolderSync>
EOF

is($req->sync_key, 0);
