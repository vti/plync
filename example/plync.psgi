#!/usr/bin/env perl

use strict;
use warnings;

use lib 'lib';

use Plync;
use Plync::User;
use Plync::UserManager;
use Plync::Storage;

my $storage = Plync::Storage->new;
$storage->save(
    'user:foo' => Plync::User->new(
        username => 'foo',
        password => 'bar'
    ),
    sub { }
);

Plync->new(user_manager => Plync::UserManager->new(storage => $storage));
