use strict;
use warnings;

use Test::More tests => 3;

use_ok('Plync');

use Plack::Test;
use Plack::Builder;
use HTTP::Request;

my $app = builder {
    enable "ContentLength";

    enable "HTTPExceptions";

    sub {
        my $env = shift;

        return Plync->dispatch($env);
    };
};

test_psgi $app, sub {
    my $cb  = shift;

    my $req = HTTP::Request->new(OPTIONS => '/');
    my $res = $cb->($req);

    is $res->content, '';
};

test_psgi $app, sub {
    my $cb  = shift;

    my $req = HTTP::Request->new(GET => '/');
    my $res = $cb->($req);

    is $res->content, 'Bad Request';
};
