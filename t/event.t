use strict;
use warnings;

use Test::More tests => 3;

use_ok('Plync::Event');

use XML::LibXML;

my $doc  = XML::LibXML::Document->new;
my $root = $doc->createElement('root');
$doc->setDocumentElement($root);

my $event = Plync::Event->new(
    subject    => 'Drink',
    start_time => '20110613T000000Z',
    end_time   => '20110614T000000Z',
);
$event->appendTo($doc, $doc->documentElement);

is($doc->toString(2), <<'EOF');
<?xml version="1.0"?>
<root xmlns:airsyncbase="AirSyncBase:" xmlns:calendar="Calendar:">
  <calendar:EndTime>20110614T000000Z</calendar:EndTime>
  <calendar:Subject>Drink</calendar:Subject>
  <calendar:StartTime>20110613T000000Z</calendar:StartTime>
</root>
EOF

$doc  = XML::LibXML::Document->new;
$root = $doc->createElement('root');
$doc->setDocumentElement($root);

$event = Plync::Event->new(
    time_zone      => 'Europe/Berlin',
    all_day_event => 0,
    body          => {
        type                => 3,
        truncated           => 0,
        estimated_data_size => 0
    },
    busy_status                  => 0,
    organizer_name               => '',
    organizer_email              => '',
    DT_stamp                     => '20110612T122025Z',
    end_time                     => '20110614T000000Z',
    location                     => 'Subway',
    reminder                     => 0,
    sensitivity                  => 0,
    subject                      => 'Drink',
    start_time                   => '20110613T000000Z',
    UID                          => 'foo@bar.com',
    meeting_status               => 1,
    attendees                    => [],
    categories                   => [],
    recurrence                   => {},
    exceptions                   => {},
    response_requested           => 0,
    appointment_reply_time       => undef,
    response_type                => 3,
    disallow_new_time_proposal   => 0,
    native_body_type             => 3,
    online_meeting_conf_link     => undef,
    online_meeting_external_link => undef
);
$event->appendTo($doc, $doc->documentElement);

is($doc->toString(2), <<'EOF');
<?xml version="1.0"?>
<root xmlns:airsyncbase="AirSyncBase:" xmlns:calendar="Calendar:">
  <calendar:TimeZone>PAAAAENFVAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAoAAAAFAAMAAAAAAAAAAAAAAENFU1QAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAMAAAAFAAIAAAAAAAAAxP///w==</calendar:TimeZone>
  <calendar:AllDayEvent>0</calendar:AllDayEvent>
  <airsyncbase:Body>
    <airsyncbase:Type>3</airsyncbase:Type>
    <airsyncbase:EstimatedDataSize>0</airsyncbase:EstimatedDataSize>
    <airsyncbase:Truncated>0</airsyncbase:Truncated>
  </airsyncbase:Body>
  <calendar:BusyStatus>0</calendar:BusyStatus>
  <calendar:OrganizerName/>
  <calendar:OrganizerEmail/>
  <calendar:DTStamp>20110612T122025Z</calendar:DTStamp>
  <calendar:EndTime>20110614T000000Z</calendar:EndTime>
  <calendar:Location>Subway</calendar:Location>
  <calendar:Reminder>0</calendar:Reminder>
  <calendar:Sensitivity>0</calendar:Sensitivity>
  <calendar:Subject>Drink</calendar:Subject>
  <calendar:StartTime>20110613T000000Z</calendar:StartTime>
  <calendar:UID>foo@bar.com</calendar:UID>
  <calendar:MeetingStatus>1</calendar:MeetingStatus>
  <calendar:ResponseRequested>0</calendar:ResponseRequested>
  <calendar:ResponseType>3</calendar:ResponseType>
  <airsyncbase:NativeBodyType>3</airsyncbase:NativeBodyType>
</root>
EOF
