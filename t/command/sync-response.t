use strict;
use warnings;

use Test::More tests => 3;

use XML::XPath;

use_ok('Plync::Command::Sync::Response');

is( Plync::Command::Sync::Response->new(
        collections => [
            {   class         => 'Email',
                status        => 1,
                sync_key      => 7,
                collection_id => 1,
                commands      => []
            }
        ]
      )->to_string,
    <<'EOF');
<?xml version="1.0" encoding="utf-8"?>
<Sync xmlns="AirSync:">
<Collections>
<Collection>
<Class>Email</Class>
<SyncKey>7</SyncKey>
<CollectionId>1</CollectionId>
<Status>1</Status>
<Commands>
<Add>...</Add>
<Delete>...</Delete>
<Change>...</Change>
<Fetch>...</Fetch>
</Commands>
</Collection>
</Collections>
</Sync>
EOF
