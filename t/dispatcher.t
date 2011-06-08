package Plync::Command::Test;

use strict;
use warnings;

use base 'Plync::Command::Base';

sub dispatch {
    my ($xml) = @_;

    return <<'EOF';
<?xml version="1.0" encoding="utf-8"?>
<Test xmlns="Test:">
Hello!
</Test>
EOF
}

package Plync::Command::Sub;

use strict;
use warnings;

use base 'Plync::Command::Base';

sub dispatch {
    my ($xml) = @_;

    return sub {
        my $cb = shift;

        $cb->(<<'EOF');
<?xml version="1.0" encoding="utf-8"?>
<Sub xmlns="Sub:">
Hello!
</Sub>
EOF
    }
}

use Test::More tests => 9;

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

$req = <<'EOF';
<?xml version="1.0" encoding="utf-8"?>
<Sub xmlns="Sub:">
</Sub>
EOF

$res = <<'EOF';
<?xml version="1.0" encoding="utf-8"?>
<Sub xmlns="Sub:">
Hello!
</Sub>
EOF

my $cb = Plync::Dispatcher->dispatch($req);
$cb->(
    sub {
        is($_[0], $res);
    }
);
