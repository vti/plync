#!/usr/bin/env perl

use strict;
use warnings;

use lib 'lib';

use Plync;

use Plack::Builder;
use Plack::Request;

use Plync::Folder;
use Plync::Folders;

my $folders = Plync::Folders->new;
$folders->add(
    Plync::Folder->new(
        id           => 'root',
        parent_id    => 0,
        type         => 2,
        class        => 'Email',
        display_name => 'Inbox'
      )
);
$folders->add(
    Plync::Folder->new(
        id           => 2,
        parent_id    => 0,
        type         => 12,
        class        => 'Email',
        display_name => 'Yahoo2'
      )
);
$folders->save;

my $app = sub {
    my $env = shift;

    return Plync->dispatch($env);
};

builder {
    enable "ContentLength";

    enable "HTTPExceptions";

    enable "Auth::Basic", authenticator => sub {
        my ($username, $password) = @_;
        return $username eq 'foo' && $password eq 'bar';
    };

    $app;
};