use strict;
use warnings;

use Test::More tests => 3;

use XML::XPath;

use_ok('Plync::Command::Sync::Request');

my $req = Plync::Command::Sync::Request->new->parse(<<'EOF');
<?xml version="1.0" encoding="UTF-8"?>
<Sync xmlns="AirSync:">
  <Collections>
    <Collection>
      <Class>Email</Class>
      <SyncKey>6</SyncKey>
      <CollectionId>1</CollectionId>
      <DeletesAsMoves/>
      <GetChanges/>
      <WindowSize>25</WindowSize>
      <Options>
        <FilterType>2</FilterType>
        <Truncation>1</Truncation>
        <MIMETruncation>1</MIMETruncation>
        <MIMESupport>0</MIMESupport>
      </Options>
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
            options          => {
                filter_type     => 2,
                truncation      => 1,
                mime_truncation => 1,
                mime_support    => 0
            }
        }
    ]
);

$req = Plync::Command::Sync::Request->new->parse(<<'EOF');
<?xml version="1.0" encoding="UTF-8"?>
<Sync xmlns="AirSync:">
  <Collections>
    <Collection>
      <Class>Email</Class>
      <SyncKey>6</SyncKey>
      <CollectionId>1</CollectionId>
      <DeletesAsMoves/>
      <Options>
        <FilterType>2</FilterType>
        <MIMESupport>2</MIMESupport>
      </Options>
      <Commands>
        <Fetch>
          <ServerId>1:123</ServerId>
        </Fetch>
      </Commands>
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
            options          => {
                filter_type  => 2,
                mime_support => 2
            },
            commands => [fetch => {server_id => '1:123'}]
        }
    ]
);
