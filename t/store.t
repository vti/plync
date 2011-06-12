use strict;
use warnings;

use Test::More tests => 6;

BEGIN {
    $ENV{PLYNC_HOME} = 't';
    rmdir "$ENV{PLYNC_HOME}/store";
}

use_ok('Plync::Storable');

my $store = Plync::Storable->new(id => 1, foo => 'bar');
ok $store->save;

$store = Plync::Storable->new(id => 1);
ok $store->load;
is($store->id, 1);

ok $store->delete;
$store = Plync::Storable->new(id => 1);
ok !$store->load;

rmdir "$ENV{PLYNC_HOME}/store";
