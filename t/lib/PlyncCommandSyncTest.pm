package PlyncCommandSyncTest;

use strict;
use warnings;

use base 'PlyncCommandTestBase';

use Test::Plync;

sub make_fixture : Test(setup) {
    my $self = shift;

    my $backend = Test::Plync->build_backend;
    my $device = Test::Plync->build_device(backend => $backend);
    $device->fetch_folders(sub { });

    $self->{device} = $device;
}

sub test_initial : Test {
    my $self = shift;

    my $in = <<'EOF';
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

    my $out = <<'EOF';
<?xml version="1.0" encoding="UTF-8"?>
<Sync xmlns="AirSync:">
  <Status>1</Status>
  <Collections>
    <Collection>
      <SyncKey>1</SyncKey>
      <CollectionId>1</CollectionId>
      <Status>1</Status>
      <Class>Email</Class>
    </Collection>
  </Collections>
</Sync>
EOF

    is $self->_run_command('Sync', $in), $out;
}

sub test_invalid_sync_key : Test {
    my $self = shift;

    my $in = <<'EOF';
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

    my $out = <<'EOF';
<?xml version="1.0" encoding="UTF-8"?>
<Sync xmlns="AirSync:">
  <Status>1</Status>
  <Collections>
    <Collection>
      <SyncKey>0</SyncKey>
      <CollectionId>1</CollectionId>
      <Status>3</Status>
      <Class>Email</Class>
    </Collection>
  </Collections>
</Sync>
EOF

    is $self->_run_command('Sync', $in), $out;
}

sub test_initial_invalid_collection_id : Test {
    my $self = shift;

    my $in = <<'EOF';
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

    my $out = <<'EOF';
<?xml version="1.0" encoding="UTF-8"?>
<Sync xmlns="AirSync:">
  <Status>12</Status>
</Sync>
EOF

    is $self->_run_command('Sync', $in), $out;
}

sub test_invalid_collection_id : Test {
    my $self = shift;

    $self->_run_initial_sync;

    my $in = <<'EOF';
<?xml version="1.0" encoding="UTF-8"?>
<Sync xmlns="AirSync:" xmlns:airsyncbase="AirSyncBase:">
  <Collections>
    <Collection>
      <Class>Email</Class>
      <SyncKey>1</SyncKey>
      <CollectionId>unknown</CollectionId>
    </Collection>
  </Collections>
</Sync>
EOF

    my $out = <<'EOF';
<?xml version="1.0" encoding="UTF-8"?>
<Sync xmlns="AirSync:">
  <Status>12</Status>
</Sync>
EOF

    is $self->_run_command('Sync', $in), $out;
}

sub test_fetch_folder_with_items : Test {
    my $self = shift;

    $self->_run_initial_sync;

    my $in = <<'EOF';
<?xml version="1.0" encoding="UTF-8"?>
<Sync xmlns="AirSync:" xmlns:airsyncbase="AirSyncBase:">
  <Collections>
    <Collection>
      <Class>Email</Class>
      <SyncKey>1</SyncKey>
      <CollectionId>1</CollectionId>
    </Collection>
  </Collections>
</Sync>
EOF

    my $out = <<'EOF';
<?xml version="1.0" encoding="UTF-8"?>
<Sync xmlns="AirSync:" xmlns:airsyncbase="AirSyncBase:" xmlns:email="Email:" xmlns:email2="Email2:">
  <Status>1</Status>
  <Collections>
    <Collection>
      <SyncKey>2</SyncKey>
      <CollectionId>1</CollectionId>
      <Status>1</Status>
      <Class>Email</Class>
      <Commands>
        <Add>
          <ServerId>1</ServerId>
          <ApplicationData>
            <email:To>"Device User" &lt;deviceuser@example.com&gt;</email:To>
            <email:From>"Device User 2" &lt;deviceuser2@example.com&gt;</email:From>
            <email:Subject>New mail message</email:Subject>
            <email:DateReceived>2009-07-29T19:25:37.817Z</email:DateReceived>
            <email:InternetCPID>1252</email:InternetCPID>
            <email2:ConversationId>FF68022058BD485996BE15F6F6D99320</email2:ConversationId>
            <email2:ConversationIndex>CA2CFA8A23</email2:ConversationIndex>
          </ApplicationData>
        </Add>
      </Commands>
    </Collection>
  </Collections>
</Sync>
EOF

    is $self->_run_command('Sync', $in), $out;
}

sub test_fetch_folder_item : Test {
    my $self = shift;

    $self->_run_initial_sync;

    my $in = <<'EOF';
<?xml version="1.0" encoding="UTF-8"?>
<Sync xmlns="AirSync:" xmlns:airsyncbase="AirSyncBase:">
  <Collections>
    <Collection>
      <Class>Email</Class>
      <SyncKey>1</SyncKey>
      <CollectionId>1</CollectionId>
      <Commands>
        <Fetch>
          <ServerId>1</ServerId>
        </Fetch>
      </Commands>
    </Collection>
  </Collections>
</Sync>
EOF

    my $out = <<'EOF';
<?xml version="1.0" encoding="UTF-8"?>
<Sync xmlns="AirSync:" xmlns:airsyncbase="AirSyncBase:" xmlns:email="Email:" xmlns:email2="Email2:">
  <Status>1</Status>
  <Collections>
    <Collection>
      <SyncKey>1</SyncKey>
      <CollectionId>1</CollectionId>
      <Status>1</Status>
      <Class>Email</Class>
      <Responses>
        <Fetch>
          <ServerId>1</ServerId>
          <Status>1</Status>
          <ApplicationData>
            <email:To>"Device User" &lt;deviceuser@example.com&gt;</email:To>
            <email:From>"Device User 2" &lt;deviceuser2@example.com&gt;</email:From>
            <email:Subject>New mail message</email:Subject>
            <email:DateReceived>2009-07-29T19:25:37.817Z</email:DateReceived>
            <email:InternetCPID>1252</email:InternetCPID>
            <email2:ConversationId>FF68022058BD485996BE15F6F6D99320</email2:ConversationId>
            <email2:ConversationIndex>CA2CFA8A23</email2:ConversationIndex>
          </ApplicationData>
        </Fetch>
      </Responses>
    </Collection>
  </Collections>
</Sync>
EOF

    is $self->_run_command('Sync', $in), $out;
}

sub _run_initial_sync {
    my $self = shift;

    my $in = <<'EOF';
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

    $self->_run_command('Sync', $in);
}

1;
