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

use Test::More tests => 8;

use_ok('Plync::Dispatcher');

eval { Plync::Dispatcher->dispatch };
isa_ok($@, 'Plync::HTTPException');
is($@->message, 'Malformed XML');

eval { Plync::Dispatcher->dispatch('asdasd') };
isa_ok($@, 'Plync::HTTPException');
is($@->message, 'Malformed XML');

eval {
    Plync::Dispatcher->dispatch(
        '<?xml version="1.0" encoding="utf-8"?><Foo xmlns="Foo:"></Foo>');
};
isa_ok($@, 'Plync::HTTPException');
is($@->message, 'Not supported');

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

is_deeply(Plync::Dispatcher->dispatch($req), $res);
