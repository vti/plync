package Plync::DevicePool;

use strict;
use warnings;

use Scalar::Util qw(blessed);

use Plync::Device;

use constant DEBUG => $ENV{PLYNC_POOL_DEBUG};

sub find_device {
    my $self = shift;
    my ($device) = @_;

    my $id = blessed $device ? $device->id : $device;

    return $self->_instance->{devices}->{$id};
}

sub add_device {
    my $self = shift;

    my $device = $self->_build_device(@_);

    $self->_instance->{devices}->{$device->id} = $device;

    DEBUG && warn "Added device '" . $device->id . "'\n";

    return $device;
}

sub devices {
    my $self = shift;

    return values %{$self->_instance->{devices}};
}

sub remove_device {
    my $self = shift;

    my $id = blessed $_[0] ? $_[0]->id : $_[0];

    delete $self->_instance->{devices}->{$id};

    DEBUG && warn "Removed device '" . $id . "'\n";
}

sub _instance {
    my $class = shift;

    no strict;

    ${"$class\::_instance"} ||= $class->_new_instance(@_);

    return ${"$class\::_instance"};
}

sub _new_instance {
    my $class = shift;

    my $self = bless {@_}, $class;

    $self->{devices} = {};

    return $self;
}

sub _build_device {
    my $self = shift;

    return Plync::Device->new(@_);
}

1;
