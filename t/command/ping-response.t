use strict;
use warnings;

use Test::More tests => 5;

use XML::XPath;

use_ok('Plync::Command::Ping::Response');

my $res = Plync::Command::Ping::Response->new;
is($res->to_string(2), <<'EOF');
<?xml version="1.0" encoding="utf-8"?>
<Ping xmlns="Ping:">
  <Status>1</Status>
</Ping>
EOF

#my $xmlschema = XML::LibXML::Schema->new(location => 'schemas/ping-response.xsd');
#$xmlschema->validate($res->dom);

$res = Plync::Command::Ping::Response->new;
$res->status(2);
$res->add_folder(1234);
$res->add_folder(5678);
is($res->to_string(2), <<'EOF');
<?xml version="1.0" encoding="utf-8"?>
<Ping xmlns="Ping:">
  <Status>2</Status>
  <Folders>
    <Folder>1234</Folder>
    <Folder>5678</Folder>
  </Folders>
</Ping>
EOF

$res = Plync::Command::Ping::Response->new;
$res->status(5);
$res->interval(60);
is($res->to_string(2), <<'EOF');
<?xml version="1.0" encoding="utf-8"?>
<Ping xmlns="Ping:">
  <Status>5</Status>
  <HeartbeatInterval>60</HeartbeatInterval>
</Ping>
EOF

$res = Plync::Command::Ping::Response->new;
$res->status(6);
$res->max_folders(200);
is($res->to_string(2), <<'EOF');
<?xml version="1.0" encoding="utf-8"?>
<Ping xmlns="Ping:">
  <Status>6</Status>
  <MaxFolders>200</MaxFolders>
</Ping>
EOF
