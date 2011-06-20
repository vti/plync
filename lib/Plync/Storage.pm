package Plync::Storage;

use strict;
use warnings;

use Class::Load ();

sub new {
    my $class = shift;

    my $self = {@_};
    bless $self, $class;

    $self->{driver} ||= 'Memory';

    return $self;
}

sub load {
    my $self = shift;

    return $self->_driver->load(@_);
}

sub save {
    my $self = shift;

    return $self->_driver->save(@_);
}

sub delete {
    my $self = shift;

    return $self->_driver->delete(@_);
}

sub _driver {
    my $self = shift;

    $self->{_driver} ||= do {
        my $driver_class = __PACKAGE__ . '::' . $self->{driver};

        Class::Load::load_class($driver_class);

        $driver_class->new(@_);
    };

    return $self->{_driver};
}

1;
