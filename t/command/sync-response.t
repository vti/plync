use strict;
use warnings;

use Test::More tests => 3;

use XML::XPath;

use_ok('Plync::Command::Sync::Response');

my $res = Plync::Command::Sync::Response->new;
$res->add_collection(
    class         => 'Email',
    status        => 1,
    sync_key      => '{ba5d68fb-5dcb-4f27-9c92-a9f3c5f245a6}1',
    collection_id => 1,
    commands      => []
);

is($res->to_string, <<'EOF');
<?xml version="1.0" encoding="UTF-8"?>
<Sync xmlns="AirSync:"><Collections><Collection><Class>Email</Class><SyncKey>{ba5d68fb-5dcb-4f27-9c92-a9f3c5f245a6}1</SyncKey><CollectionId>1</CollectionId><Status>1</Status></Collection></Collections></Sync>
EOF

use Plync::Data::Email;
my $email = Plync::Data::Email->new(
    to            => '"Device User" <deviceuser@example.com>',
    from          => '"Device User 2" <deviceuser2@example.com>',
    subject       => 'New mail message',
    date_received => '2009-07-29T19:25:37.817Z',
    display_to    => 'Device User',
    thread_topic  => 'New mail message',
    importance    => 1,
    read          => 0,
    body          => {
        type                => 2,
        estimated_data_size => 116575,
        truncated           => 1
    },
    message_class      => 'IPM.Note',
    internet_CPID      => '1252',
    content_class      => 'urn:content-classes:message',
    native_body_type   => '2',
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

is($res->to_string, <<'EOF');
<?xml version="1.0" encoding="UTF-8"?>
<Sync xmlns="AirSync:" xmlns:airsyncbase="AirSyncBase:" xmlns:email="Email:" xmlns:email2="Email2:"><Collections><Collection><SyncKey>927479210</SyncKey><CollectionId>5</CollectionId><Status>1</Status><Commands><Add><ServerId>5:1</ServerId><ApplicationData><email:To>"Device User" &lt;deviceuser@example.com&gt;</email:To><email:From>"Device User 2" &lt;deviceuser2@example.com&gt;</email:From><email:Subject>New mail message</email:Subject><email:DateReceived>2009-07-29T19:25:37.817Z</email:DateReceived><email:DisplayTo>Device User</email:DisplayTo><email:ThreadTopic>New mail message</email:ThreadTopic><email:Importance>1</email:Importance><email:Read>0</email:Read><airsyncbase:Body><airsyncbase:Type>2</airsyncbase:Type><airsyncbase:EstimatedDataSize>116575</airsyncbase:EstimatedDataSize><airsyncbase:Truncated>1</airsyncbase:Truncated></airsyncbase:Body><email:MessageClass>IPM.Note</email:MessageClass><email:InternetCPID>1252</email:InternetCPID><email:Flag/><email:ContentClass>urn:content-classes:message</email:ContentClass><airsyncbase:NativeBodyType>2</airsyncbase:NativeBodyType><email2:ConversationId>FF68022058BD485996BE15F6F6D99320</email2:ConversationId><email2:ConversationIndex>CA2CFA8A23</email2:ConversationIndex><email:Categories/></ApplicationData></Add></Commands></Collection></Collections></Sync>
EOF
