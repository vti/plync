use strict;
use warnings;

use Test::More tests => 10;

BEGIN {
    $ENV{PLYNC_HOME} = 't';
    rmdir "$ENV{PLYNC_HOME}/store";
}

use_ok('Plync::User');

my $user = Plync::User->new(username => 'foo', password => '123');
$user->save;

is($user->username, 'foo');
isnt($user->password, '123');

$user = Plync::User->new(username => 'foo');
ok $user->load;

is($user->username, 'foo');
ok($user->check_password('123'));
ok(!$user->check_password('hello'));

ok $user->delete;
ok !$user->load;
ok !$user->username;

rmdir "$ENV{PLYNC_HOME}/store";
