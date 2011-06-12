use strict;
use warnings;

use Test::More tests => 5;

use_ok('Plync');

use Plack::Test;
use Plack::Builder;
use HTTP::Request;

my $app = Plync->new->psgi_app;

test_psgi $app, sub {
    my $cb  = shift;

    my $req = HTTP::Request->new(OPTIONS => '/', ['Authorization' => 'Basic Zm9vOmJhcg==']);
    my $res = $cb->($req);

    ok($res->headers->header('ms-asprotocolversions'));

    is $res->content, '';
};

test_psgi $app, sub {
    my $cb  = shift;

    my $req = HTTP::Request->new(GET => '/', ['Authorization' => 'Basic 123==']);
    my $res = $cb->($req);

    is $res->content, 'Authorization required';
};

test_psgi $app, sub {
    my $cb  = shift;

    my $req = HTTP::Request->new(GET => '/', ['Authorization' => 'Basic Zm9vOmJhcg==']);
    my $res = $cb->($req);

    is $res->content, 'Bad Request';
};
