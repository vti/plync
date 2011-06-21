use strict;
use warnings;

use Test::More tests => 2;

use_ok('Plync::Email');

my $email = Plync::Email->new(
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

my $doc = XML::LibXML::Document->new;
my $root = $doc->createElement('root');
$doc->setDocumentElement($root);

$email->appendTo($doc, $doc->documentElement);

is($doc->toString(2), <<'EOF');
<?xml version="1.0"?>
<root xmlns:airsyncbase="AirSyncBase:" xmlns:email="Email:" xmlns:email2="Email2:">
  <email:To>"Device User" &lt;deviceuser@example.com&gt;</email:To>
  <email:From>"Device User 2" &lt;deviceuser2@example.com&gt;</email:From>
  <email:Subject>New mail message</email:Subject>
  <email:DateReceived>2009-07-29T19:25:37.817Z</email:DateReceived>
  <email:DisplayTo>Device User</email:DisplayTo>
  <email:ThreadTopic>New mail message</email:ThreadTopic>
  <email:Importance>1</email:Importance>
  <email:Read>0</email:Read>
  <airsyncbase:Body>
    <airsyncbase:Type>2</airsyncbase:Type>
    <airsyncbase:EstimatedDataSize>116575</airsyncbase:EstimatedDataSize>
    <airsyncbase:Truncated>1</airsyncbase:Truncated>
  </airsyncbase:Body>
  <email:MessageClass>IPM.Note</email:MessageClass>
  <email:InternetCPID>1252</email:InternetCPID>
  <email:ContentClass>urn:content-classes:message</email:ContentClass>
  <airsyncbase:NativeBodyType>2</airsyncbase:NativeBodyType>
  <email2:ConversationId>FF68022058BD485996BE15F6F6D99320</email2:ConversationId>
  <email2:ConversationIndex>CA2CFA8A23</email2:ConversationIndex>
</root>
EOF
