package Plync::Command::Ping;

use strict;
use warnings;

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

my $malformed_wbxml = [
    400, ['Content-Type' => 'plain/text', 'Content-Length' => 15],
    ['Malformed wbxml']
];

is_deeply(Plync::Dispatcher::WBXML->dispatch(''), $malformed_wbxml);
is_deeply(Plync::Dispatcher::WBXML->dispatch('123'), $malformed_wbxml);

my $req = pack 'H*', '03016a00000d45480338300001494a4b033500014c03456d61696c0001010101';
my $res = pack 'H*', '03016a00000d45030a48656c6c6f210a0001';

is(Plync::Dispatcher::WBXML->dispatch($req), $res);
