package Plync::Storage;

use strict;
use warnings;

use Class::Load ();

sub set_driver {
    my $class = shift;
    my ($driver) = @_;

    $class->_instance->{driver} = $driver;
}

sub load {
    my $class = shift;

    return $class->_driver->load(@_);
}

sub save {
    my $class = shift;

    return $class->_driver->save(@_);
}

sub delete {
    my $class = shift;

    return $class->_driver->delete(@_);
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

    $self->{driver} = 'Memory';

    return $self;
}

sub _driver {
    my $class = shift;

    $class->_instance->{_driver} ||= do {
        my $driver_class = __PACKAGE__ . '::' . $class->_instance->{driver};

        Class::Load::load_class($driver_class);

        $driver_class->new(@_);
    };

    return $class->_instance->{_driver};
}

1;
