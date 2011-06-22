package Plync::FolderSyncable;

use strict;
use warnings;

use base 'Plync::Syncable';

sub new {
    my $class = shift;
    my ($decorated) = shift;

    return $class->SUPER::new(decorated => $decorated, @_);
}

sub id           { shift->{decorated}->id(@_) }
sub parent_id    { shift->{decorated}->parent_id(@_) }
sub class        { shift->{decorated}->class(@_) }
sub type         { shift->{decorated}->type(@_) }
sub display_name { shift->{decorated}->display_name(@_) }
sub add_item     { shift->{decorated}->add_item(@_) }
sub items        { shift->{decorated}->items(@_) }

1;
