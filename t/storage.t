package Object;

sub new { bless {@_}, $_[0] }

sub id {1}

use strict;
use warnings;

use Test::More tests => 5;

use_ok('Plync::Storage');

Plync::Storage->save(1, Object->new(foo => 'bar'), sub { });

Plync::Storage->load(
    2,
    sub {
        ok !$_[1];
    }
);

Plync::Storage->load(
    1,
    sub {
        ok $_[1];
        is $_[1]->id, 1;
    }
);

Plync::Storage->delete(1, sub { });

Plync::Storage->load(
    1,
    sub {
        ok !$_[1];
    }
);
