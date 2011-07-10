use strict;
use warnings;

use Test::More tests => 3;

use XML::LibXML;

use_ok('Plync::Backend::Calendar::vCalendar::Parser');

my $string = do {
    local $/;
    open my $fh, '<', 't/backend/vcalendar/calendar.ics' or die $!;
    <$fh>;
};

my $events = Plync::Backend::Calendar::vCalendar::Parser->parse($string);
is(@$events, 1);

my $event = $events->[0];

my $doc = XML::LibXML::Document->new;
my $root = $doc->createElement('root');
$doc->setDocumentElement($root);

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
