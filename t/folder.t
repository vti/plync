use strict;
use warnings;

use Test::More tests => 3;

use_ok('Plync::Folder');

my $email = Plync::Folder->new(
    id           => 1,
    class        => 'Email',
    type         => 'Inbox',
    display_name => 'Inbox'
);
ok $email;
is($email->checksum, '29cd1bfd3743243d5217e365c8eb7c5d');
