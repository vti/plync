use strict;
use warnings;

use Test::More tests => 2;

use_ok('Plync::Dispatcher');

my $malformed_xml = [
    400,
    [   'Content-Type'   => 'plain/text',
        'Content-Length' => 13
    ],
    ['Malformed XML']
];


my $not_supported = [
    501,
    [   'Content-Type'   => 'plain/text',
        'Content-Length' => 13
    ],
    ['Not supported']
];

is_deeply(Plync::Dispatcher->dispatch,           $malformed_xml);
is_deeply(Plync::Dispatcher->dispatch('asdasd'), $malformed_xml);

is_deeply(
    Plync::Dispatcher->dispatch(
        '<?xml version="1.0" encoding="utf-8"?><Foo xmlns="Foo:"></Foo>'),
    $not_supported
);

is(Plync::Dispatcher->dispatch(<<'EOF'), '');
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
