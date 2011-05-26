use strict;
use warnings;

use Test::More tests => 1;

use XML::XPath;

use_ok('Plync::Command::Ping');

my $xml = <<'EOF';
<?xml version="1.0" encoding="utf-8"?>
<Ping xmlns="Ping:">
<HeartbeatInterval>80</HeartbeatInterval>
<Folders>
<Folder>
<Id>5</Id>
<Class>Email</Class>
</Folder>
</Folders>
</Ping>
EOF

my $xpath = XML::XPath->new($xml);

is(Plync::Command::Ping->new->dispatch($xpath), '');
