package Plync::Storable::File;

use strict;
use warnings;

use base 'Plync::Storable::Base';

use File::Path ();
use Storable ();

our $DIRECTORY = File::Spec->catfile(($ENV{PLYNC_HOME} || '.'), 'store');

sub new {
    my $self = shift->SUPER::new(@_);

    $self->_prepare_directory;

    return $self;
}

sub load {
    my $self = shift;
    my ($id) = @_;

    my $path = $self->_path_to($id);

    return unless -e $path;

    return Storable::retrieve($path) or die $!;
}

sub save {
    my $self = shift;
    my ($object, $id) = @_;

    Storable::store($object, $self->_path_to($id)) or die $!;
}

sub delete {
    my $self = shift;
    my ($id) = @_;

    unlink $self->_path_to($id) or die $!;
}

sub _prepare_directory {
    my $self = shift;

    return if -d $DIRECTORY;

    File::Path::mkpath($DIRECTORY) or die $!;
}

sub _path_to {
    my $self = shift;

    return File::Spec->catfile($DIRECTORY, @_);
}

1;
