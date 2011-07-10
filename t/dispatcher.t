package Plync::Command::Test;
use base 'Plync::Command::Base';

package Plync::Command::Test::Request;
use base 'Plync::Command::BaseRequest';

package Plync::Command::Test::Response;
use base 'Plync::Command::BaseResponse';

package Plync::Command::Sub;
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

eval { Plync::Dispatcher->new->dispatch('Test') };
isa_ok($@, 'Plync::HTTPException');
is($@->message, 'Malformed XML');

eval { Plync::Dispatcher->new->dispatch('Test', 'asdasd') };
isa_ok($@, 'Plync::HTTPException');
is($@->message, 'Malformed XML');

eval { Plync::Dispatcher->new->dispatch('Foo', ''); };
isa_ok($@, 'Plync::HTTPException');
is($@->message, 'Not supported');

my $req = <<'EOF';
<?xml version="1.0" encoding="utf-8"?>
<Test xmlns="Test:">
</Test>
EOF

my $res = '';

is_deeply(Plync::Dispatcher->new->dispatch('Test', $req), undef);

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

my $cb = Plync::Dispatcher->new->dispatch('Sub', $req);
$cb->(
    sub {
        is($_[0], $res);
    }
);
