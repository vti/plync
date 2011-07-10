#!/usr/bin/env perl

use strict;
use warnings;

use lib 'lib';

use Plync;
use Plync::User;
use Plync::Backend;
use Plync::UserManager;

Plync::Storage->save(
    'user:foo' => Plync::User->new(
        username => 'foo',
        password => 'bar'
    ),
    sub { }
);

Plync->new(
    backends => {
        calendar => Plync::Backend->new(
            'Calendar', 'vCalendar', path => 'calendar.ics'
        )
    },
    user_manager => Plync::UserManager->new
);
