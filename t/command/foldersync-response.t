use strict;
use warnings;

use Test::More tests => 2;

use XML::XPath;

use_ok('Plync::Command::FolderSync::Response');

#is(Plync::Command::FolderSync::Response->new->to_string, <<'EOF');
#EOF

is( Plync::Command::FolderSync::Response->new(
        status   => 1,
        sync_key => 1,
        changes  => [
            {   server_id    => 1,
                parent_id    => 0,
                display_name => 'Calendar',
                type         => 8
            },
        ]
      )->to_string,
    <<'EOF');
<?xml version="1.0" encoding="utf-8"?>
<FolderSync xmlns="FolderHierarchy:"><Status>1</Status><SyncKey>1</SyncKey><Changes><Count>1</Count><Add><ServerId>1</ServerId><ParentId>0</ParentId><DisplayName>Calendar</DisplayName><Type>8</Type></Add></Changes></FolderSync>
EOF
