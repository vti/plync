package Plync::Storable;

use strict;
use warnings;

our $DRIVER = 'File';

use Plync::Storable::File;

sub new {
    my $class = shift;

    my $self = {@_};
    bless $self, $class;

    return $self;
}

sub id { $_[0]->{id} }

sub load {
    my $self = shift;

    my $load = $self->_store->load($self->id);

    unless ($load) {
        %$self = ();
        return;
    }

    %$self = %$load;

    return $self;
}

sub save {
    my $self = shift;

    $self->_store->save($self, $self->id);

    return $self;
}

sub delete {
    my $self = shift;

    $self->_store->delete($self->id);

    return $self;
}

sub _store {
    my $self = shift;

    $self->{store} ||= do {
        my $driver_class = __PACKAGE__ . '::' . $DRIVER;

        $driver_class->new(@_);
    };

    return $self->{store};
}

1;
