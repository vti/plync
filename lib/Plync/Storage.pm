package Plync::Storage;

use strict;
use warnings;

our $DRIVER = 'File';

use Plync::Storage::File;

sub new {
    my $class = shift;

    my $self = {@_};
    bless $self, $class;

    return $self;
}

sub load {
    my $self = shift;

    return $self->_driver->load(@_);
}

sub save {
    my $self = shift;
    my ($object) = @_;

    my $id = $object->id;

    return $self->_driver->save($id, $object);
}

sub delete {
    my $self = shift;

    return $self->_driver->delete(@_);
}

sub _driver {
    my $self = shift;

    $self->{driver} ||= do {
        my $driver_class = __PACKAGE__ . '::' . $DRIVER;

        $driver_class->new(@_);
    };

    return $self->{driver};
}

1;
