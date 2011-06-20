use strict;
use warnings;

use Test::More tests => 4;

use_ok('Plync::UserManager');

use Plync::User;
use Plync::Storage;

my $storage = Plync::Storage->new;
$storage->save("user:foo",
    Plync::User->new(username => 'foo', password => 'bar'),
    sub { });

my $user_manager = Plync::UserManager->new(storage => $storage);

my $failed = 0;
$user_manager->authorize('hello', 'there', sub { }, sub { $failed = 1 });
ok($failed);

$failed = 0;
$user_manager->authorize('foo', 'there', sub { }, sub { $failed = 1 });
ok($failed);

my $ok = 0;
$user_manager->authorize('foo', 'bar', sub { $ok = 1 }, sub { });
ok($ok);
