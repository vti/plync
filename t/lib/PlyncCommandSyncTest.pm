package PlyncCommandSyncTest;

use strict;
use warnings;

use base 'PlyncCommandTestBase';

use Test::Plync;
use Plync::Email;
use Plync::Folder;
use Plync::FolderSet;

sub make_fixture : Test(setup) {
    my $self = shift;

    my $item = Plync::Email->new(
        id                 => 1,
        to                 => '"Device User" <deviceuser@example.com>',
        from               => '"Device User 2" <deviceuser2@example.com>',
        subject            => 'New mail message',
        date_received      => '2009-07-29T19:25:37.817Z',
        internet_CPID      => '1252',
        conversation_id    => 'FF68022058BD485996BE15F6F6D99320',
        conversation_index => 'CA2CFA8A23'
    );

    my $folder = Plync::Folder->new(
        id           => 1,
        class        => 'Email',
        type         => 'Inbox',
        display_name => 'Inbox'
    );
    $folder->add_item($item);

    my $backend = Test::Plync->build_backend(
        fetch_folders => sub {
            my $self = shift;
            my ($cb) = @_;

            my $folder_set = Plync::FolderSet->new;
            $folder_set->add($folder);

            $cb->($self, $folder_set);
        },
        fetch_folder => sub {
            my $self = shift;
            my ($folder_id, $cb) = @_;

            $cb->($self, $folder);
        },
        fetch_item => sub {
            my $self = shift;
            my ($folder_id, $item_id, $cb) = @_;

            $cb->($self, $item);
        }
    );

    my $device = Test::Plync->build_device(id => 1, backends => {email => $backend});
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
      <SyncKey>29cd1bfd3743243d5217e365c8eb7c5d</SyncKey>
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
      <SyncKey>29cd1bfd3743243d5217e365c8eb7c5d</SyncKey>
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
      <SyncKey>29cd1bfd3743243d5217e365c8eb7c5d</SyncKey>
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
      <SyncKey>29cd1bfd3743243d5217e365c8eb7c5d</SyncKey>
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
      <SyncKey>29cd1bfd3743243d5217e365c8eb7c5d</SyncKey>
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
