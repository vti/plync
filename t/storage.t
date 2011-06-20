package Object;

sub new { bless {@_}, $_[0] }

sub id {1}

use strict;
use warnings;

use Test::More tests => 5;

use_ok('Plync::Storage');

my $storage = Plync::Storage->new;

$storage->save(1, Object->new(foo => 'bar'), sub { });

$storage->load(
    2,
    sub {
        ok !$_[1];
    }
);

$storage->load(
    1,
    sub {
        ok $_[1];
        is $_[1]->id, 1;
    }
);

$storage->delete(1, sub { });

$storage->load(
    1,
    sub {
        ok !$_[1];
    }
);
