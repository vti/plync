package Plync::Command::Test;

use strict;
use warnings;

sub dispatch {
    my ($xml) = @_;

    return <<'EOF';
<?xml version="1.0" encoding="utf-8"?>
<Test xmlns="Test:">
Hello!
</Test>
EOF
}

use Test::More tests => 5;

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

my $req = <<'EOF';
<?xml version="1.0" encoding="utf-8"?>
<Test xmlns="Test:">
</Test>
EOF

my $res = <<'EOF';
<?xml version="1.0" encoding="utf-8"?>
<Test xmlns="Test:">
Hello!
</Test>
EOF

is(Plync::Dispatcher->dispatch($req), $res);
