package Plync::FolderSetSyncable;

use strict;
use warnings;

use base 'Plync::Syncable';

use Plync::FolderSyncable;

sub new {
    my $class = shift;
    my ($decorated) = shift;

    return $class->SUPER::new(decorated => $decorated, @_);
}

sub add  {
    my $self = shift;
    my ($folder) = @_;

    $self->{decorated}->add($self->_build_folder($folder));
}

sub get  { shift->{decorated}->get(@_) }
sub list { shift->{decorated}->list(@_) }

sub _build_folder {
    my $self = shift;

    Plync::FolderSyncable->new(@_);
}

1;
