use strict;
use warnings;

use Test::More tests => 2;

use_ok('Plync::Folder');

my $email = Plync::Folder->new(
    id           => 1,
    class        => 'Email',
    type         => 'Inbox',
    display_name => 'Inbox'
);
ok $email;
