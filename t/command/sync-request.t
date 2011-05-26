use strict;
use warnings;

use Test::More tests => 3;

use XML::XPath;

use_ok('Plync::Command::Sync::Request');

my $req = Plync::Command::Sync::Request->parse(<<'EOF');
<?xml version="1.0" encoding="utf-8"?>
<Sync xmlns="AirSync:">
<Collections>
<Collection>
<Class>Email</Class>
<SyncKey>6</SyncKey>
<CollectionId>1</CollectionId>
<DeletesAsMoves/>
<GetChanges/>
<Options> ... </Options>
</Collection>
</Collections>
</Sync>
EOF

is_deeply(
    $req->collections,
    [   {   class            => 'Email',
            sync_key         => 6,
            collection_id    => 1,
            deletes_as_moves => 1,
            get_changes      => 1,
            options          => []
        }
    ]
);
