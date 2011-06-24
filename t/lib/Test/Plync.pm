package Test::Plync;

use strict;
use warnings;

use base 'Test::More';

use Test::More;
use Test::MockObject::Extends;

our @EXPORT = @Test::More::EXPORT;
my $CLASS = __PACKAGE__;

use Plync::Device;
use Plync::Backend::Base;

sub build_backend {
    my $self = shift;
    my (%params) = @_;

    my $backend = Plync::Backend::Base->new();
    $backend = Test::MockObject::Extends->new($backend);

    for my $method (keys %params) {
        $backend->mock($method => $params{$method});
    }

    return $backend;
}

sub build_device {
    my $self = shift;

    my $device = Plync::Device->new(@_);
    $device = Test::MockObject::Extends->new($device);
    return $device;
}

1;
