use strict;
use warnings;

use Test::More tests => 2;

use XML::XPath;

use_ok('Plync::Command::FolderSync::Response');

my $res =
  Plync::Command::FolderSync::Response->new(status => 1, sync_key => 1);

$res->add_folder(type => 8, server_id => 1, display_name => 'Calendar');

is($res->to_string,
    <<'EOF');
<?xml version="1.0" encoding="utf-8"?>
<FolderSync xmlns="FolderHierarchy:"><Status>1</Status><SyncKey>1</SyncKey><Changes><Count>1</Count><Add><ServerId>1</ServerId><ParentId>0</ParentId><DisplayName>Calendar</DisplayName><Type>8</Type></Add></Changes></FolderSync>
EOF
