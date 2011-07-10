use strict;
use warnings;

use Test::More tests => 11;

use_ok('Plync::Command::Ping::Request');

my $req = Plync::Command::Ping::Request->new->parse('');
ok($req->is_empty);

$req = Plync::Command::Ping::Request->new->parse(<<'EOF');
<?xml version="1.0" encoding="utf-8"?>
<Ping xmlns="Ping:">
  <HeartbeatInterval>80</HeartbeatInterval>
</Ping>
EOF
ok($req->is_empty);

$req = Plync::Command::Ping::Request->new->parse(<<'EOF');
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

$req = Plync::Command::Ping::Request->new->parse(<<'EOF');
<?xml version="1.0" encoding="utf-8"?>
<Ping xmlns="Ping:">
  <HeartbeatInterval>1</HeartbeatInterval>
  <Folders>
    <Folder>
      <Id>5</Id>
      <Class>Email</Class>
    </Folder>
  </Folders>
</Ping>
EOF

is($req->error, 5);
is($req->interval, 60);

$req = Plync::Command::Ping::Request->new(max_interval => 500)->parse(<<'EOF');
<?xml version="1.0" encoding="utf-8"?>
<Ping xmlns="Ping:">
  <HeartbeatInterval>10000000</HeartbeatInterval>
  <Folders>
    <Folder>
      <Id>5</Id>
      <Class>Email</Class>
    </Folder>
  </Folders>
</Ping>
EOF

is($req->error, 5);
is($req->interval, 500);

$req = Plync::Command::Ping::Request->new(max_folders => 2)->parse(<<'EOF');
<?xml version="1.0" encoding="utf-8"?>
<Ping xmlns="Ping:">
  <HeartbeatInterval>80</HeartbeatInterval>
  <Folders>
    <Folder>
      <Id>5</Id>
      <Class>Email</Class>
    </Folder>
    <Folder>
      <Id>6</Id>
      <Class>Email</Class>
    </Folder>
    <Folder>
      <Id>7</Id>
      <Class>Email</Class>
    </Folder>
  </Folders>
</Ping>
EOF

is($req->error, 6);
is($req->max_folders, 2);
