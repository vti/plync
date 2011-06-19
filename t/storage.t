package Object;

sub new { bless {@_}, $_[0] }

sub id {1}

use strict;
use warnings;

use Test::More tests => 6;

BEGIN {
    $ENV{PLYNC_HOME} = 't';
    rmdir "$ENV{PLYNC_HOME}/storage";
}

use_ok('Plync::Storage');

ok Plync::Storage->new->save(Object->new(foo => 'bar'));

my $object = Plync::Storage->new->load(1);
ok($object);
is($object->id, 1);

ok Plync::Storage->new->delete($object->id);
ok !Plync::Storage->new->load($object->id);

rmdir "$ENV{PLYNC_HOME}/storage";
