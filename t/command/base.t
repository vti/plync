package Plync::Command::Test;
use base 'Plync::Command::Base';

sub _dispatch { }

package Plync::Command::Test::Request;
use base 'Plync::Command::BaseRequest';

sub _parse { }

package Plync::Command::Test::Response;
use base 'Plync::Command::BaseResponse';

sub build {
    'ok';
}

package Plync::Command::Test2;
use base 'Plync::Command::Base';

sub _dispatch {
    return sub {
        my $cb = shift;

        $cb->();
      }
}

package Plync::Command::Test2::Request;
use base 'Plync::Command::BaseRequest';

sub _parse { }

package Plync::Command::Test2::Response;
use base 'Plync::Command::BaseResponse';

sub build {
    'ok';
}

package main;

use strict;
use warnings;

use Test::More tests => 2;

my $command = Plync::Command::Test->new;
is($command->dispatch('<foo></foo>'), 'ok');

$command = Plync::Command::Test2->new;
my $cb = $command->dispatch('<foo></foo>');
$cb->(
    sub {
        my $res = shift;
        is($res, 'ok');
    }
);
