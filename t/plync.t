use strict;
use warnings;

use Test::More tests => 5;

use_ok('Plync');

use AnyEvent;
use Plack::Test;
use Plack::Builder;
use HTTP::Request;

use Plync::Storage;
use Plync::User;
use Plync::UserManager;

my $storage = Plync::Storage->new;
$storage->save(
    'user:foo' => Plync::User->new(
        username => 'foo',
        password => 'bar'
    ),
    sub { }
);

my $app =
  Plync->new(user_manager => Plync::UserManager->new(storage => $storage))
  ->psgi_app;

my $cv = AnyEvent->condvar;

test_psgi $app, sub {
    my $cb  = shift;

    my $req = HTTP::Request->new(OPTIONS => '/', ['Authorization' => 'Basic Zm9vOmJhcg==']);
    my $res = $cb->($req);

    ok($res->headers->header('ms-asprotocolversions'));

    is $res->content, '';

    $cv->send;
};

$cv->wait;

$cv = AnyEvent->condvar;

test_psgi $app, sub {
    my $cb  = shift;

    my $req = HTTP::Request->new(GET => '/', ['Authorization' => 'Basic 123==']);
    my $res = $cb->($req);

    is $res->content, 'Authorization required';

    $cv->send;
};

$cv->wait;

$cv = AnyEvent->condvar;

test_psgi $app, sub {
    my $cb  = shift;

    my $req = HTTP::Request->new(GET => '/', ['Authorization' => 'Basic Zm9vOmJhcg==']);
    my $res = $cb->($req);

    is $res->content, 'Bad Request';

    $cv->send;
};

$cv->wait;
