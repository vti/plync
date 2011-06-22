use strict;
use warnings;

use Test::More tests => 5;

use_ok('Plync::User');

my $user = Plync::User->new(username => 'foo', password => '123');

is($user->username, 'foo');
isnt($user->password, '123');

ok($user->check_password('123'));
ok(!$user->check_password('hello'));
