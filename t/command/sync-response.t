use strict;
use warnings;

use Test::More tests => 3;

use_ok('Plync::Command::Sync::Response');

use Plync::Email;

my $res = Plync::Command::Sync::Response->new;
$res->add_collection(
    class         => 'Email',
    status        => 1,
    sync_key      => '{ba5d68fb-5dcb-4f27-9c92-a9f3c5f245a6}1',
    collection_id => 1,
    commands      => []
);

is($res->to_string(2), <<'EOF');
<?xml version="1.0" encoding="UTF-8"?>
<Sync xmlns="AirSync:">
  <Status>1</Status>
  <Collections>
    <Collection>
      <SyncKey>{ba5d68fb-5dcb-4f27-9c92-a9f3c5f245a6}1</SyncKey>
      <CollectionId>1</CollectionId>
      <Status>1</Status>
      <Class>Email</Class>
    </Collection>
  </Collections>
</Sync>
EOF

my $email = Plync::Email->new(
    to            => '"Device User" <deviceuser@example.com>',
    from          => '"Device User 2" <deviceuser2@example.com>',
    subject       => 'New mail message',
    date_received => '2009-07-29T19:25:37.817Z',
    display_to    => 'Device User',
    internet_CPID      => '1252',
    conversation_id    => 'FF68022058BD485996BE15F6F6D99320',
    conversation_index => 'CA2CFA8A23'
);

$res = Plync::Command::Sync::Response->new;
$res->add_collection(
    status        => 1,
    sync_key      => '927479210',
    collection_id => 5,
    commands      => [
        add => {
            server_id        => '5:1',
            application_data => $email
        }
    ]
);

is($res->to_string(2), <<'EOF');
<?xml version="1.0" encoding="UTF-8"?>
<Sync xmlns="AirSync:" xmlns:airsyncbase="AirSyncBase:" xmlns:email="Email:" xmlns:email2="Email2:">
  <Status>1</Status>
  <Collections>
    <Collection>
      <SyncKey>927479210</SyncKey>
      <CollectionId>5</CollectionId>
      <Status>1</Status>
      <Commands>
        <Add>
          <ServerId>5:1</ServerId>
          <ApplicationData>
            <email:To>"Device User" &lt;deviceuser@example.com&gt;</email:To>
            <email:From>"Device User 2" &lt;deviceuser2@example.com&gt;</email:From>
            <email:Subject>New mail message</email:Subject>
            <email:DateReceived>2009-07-29T19:25:37.817Z</email:DateReceived>
            <email:DisplayTo>Device User</email:DisplayTo>
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
