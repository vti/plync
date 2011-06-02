package Plync::Command::Ping;

use strict;
use warnings;

use base 'Plync::Command::Base';

sub dispatch {
    my $class = shift;
    my ($xml) = @_;

    return <<'EOF';
<?xml version="1.0" encoding="utf-8"?>
<Ping xmlns="Ping:">
Hello!
</Ping>
EOF
}

use Test::More tests => 4;

use_ok('Plync::Dispatcher::WBXML');

eval { Plync::Dispatcher::WBXML->dispatch('') };
is($@->message, 'Malformed WBXML');

eval { Plync::Dispatcher::WBXML->dispatch('123') };
is($@->message, 'Malformed WBXML');

my $req = pack 'H*',
  '03016a00000d45480338300001494a4b033500014c03456d61696c0001010101';
my $res = pack 'H*', '03016a00000d45030a48656c6c6f210a0001';

is(Plync::Dispatcher::WBXML->dispatch($req), $res);
