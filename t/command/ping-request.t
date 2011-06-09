use strict;
use warnings;

use Test::More tests => 3;

use_ok('Plync::Command::Ping::Request');

my $req = Plync::Command::Ping::Request->new->parse(<<'EOF');
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

is($req->interval, 80);
is_deeply($req->folders, [{id => 5, class => 'Email'}]);
