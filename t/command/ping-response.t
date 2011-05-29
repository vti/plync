use strict;
use warnings;

use Test::More tests => 5;

use XML::XPath;

use_ok('Plync::Command::Ping::Response');

is(Plync::Command::Ping::Response->new->to_string, <<'EOF');
<?xml version="1.0" encoding="utf-8"?>
<Ping xmlns="Ping:"><Status>1</Status></Ping>
EOF

is(Plync::Command::Ping::Response->new(status => 2, folders => [1234, 5678])->to_string, <<'EOF');
<?xml version="1.0" encoding="utf-8"?>
<Ping xmlns="Ping:"><Status>2</Status><Folders><Folder>1234</Folder><Folder>5678</Folder></Folders></Ping>
EOF

is(Plync::Command::Ping::Response->new(status => 5, interval => 60)->to_string, <<'EOF');
<?xml version="1.0" encoding="utf-8"?>
<Ping xmlns="Ping:"><Status>5</Status><HeartbeatInterval>60</HeartbeatInterval></Ping>
EOF

is(Plync::Command::Ping::Response->new(status => 6, max_folders => 200)->to_string, <<'EOF');
<?xml version="1.0" encoding="utf-8"?>
<Ping xmlns="Ping:"><Status>6</Status><MaxFolders>200</MaxFolders></Ping>
EOF
