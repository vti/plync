use strict;
use warnings;

use Test::More tests => 4;

use_ok('Plync::Command::Sync');

use Plync::Folder;
use Plync::Folders;

my $folders = Plync::Folders->new();
$folders->add(
    Plync::Folder->new(
        id                 => 1,
        parent_id          => 0,
        type               => 2,
        class              => 'Email',
        display_name       => 'Inbox',
        sync_key_generator => sub {'1'}
    )
);
$folders->save;

my $xml = <<'EOF';
<?xml version="1.0" encoding="UTF-8"?>
<Sync xmlns="AirSync:" xmlns:airsyncbase="AirSyncBase:">
  <Collections>
    <Collection>
      <Class>Email</Class>
      <SyncKey>0</SyncKey>
      <CollectionId>1</CollectionId>
    </Collection>
  </Collections>
</Sync>
EOF

my $command = Plync::Command::Sync->new;

my $schema =
  XML::LibXML::Schema->new(location => "schemas/sync-command-response.xsd");
$schema->validate($command->dispatch($xml));

is($command->dispatch($xml)->toString, <<'EOF');
<?xml version="1.0" encoding="UTF-8"?>
<Sync xmlns="AirSync:"><Collections><Collection><Class>Email</Class><SyncKey>1</SyncKey><CollectionId>1</CollectionId><Status>1</Status></Collection></Collections></Sync>
EOF

$xml = <<'EOF';
<?xml version="1.0" encoding="UTF-8"?>
<Sync xmlns="AirSync:" xmlns:airsyncbase="AirSyncBase:">
  <Collections>
    <Collection>
      <Class>Email</Class>
      <SyncKey>123</SyncKey>
      <CollectionId>1</CollectionId>
    </Collection>
  </Collections>
</Sync>
EOF

$command = Plync::Command::Sync->new;
is($command->dispatch($xml)->toString, <<'EOF');
<?xml version="1.0" encoding="UTF-8"?>
<Sync xmlns="AirSync:"><Collections><Collection><Class>Email</Class><SyncKey>0</SyncKey><CollectionId>1</CollectionId><Status>3</Status></Collection></Collections></Sync>
EOF

$xml = <<'EOF';
<?xml version="1.0" encoding="UTF-8"?>
<Sync xmlns="AirSync:" xmlns:airsyncbase="AirSyncBase:">
  <Collections>
    <Collection>
      <Class>Email</Class>
      <SyncKey>0</SyncKey>
      <CollectionId>unknown</CollectionId>
    </Collection>
  </Collections>
</Sync>
EOF

$command = Plync::Command::Sync->new;
is($command->dispatch($xml)->toString, <<'EOF');
<?xml version="1.0" encoding="UTF-8"?>
<Sync xmlns="AirSync:"><Status>12</Status></Sync>
EOF
