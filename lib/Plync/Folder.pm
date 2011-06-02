package Plync::Folder;

use strict;
use warnings;

use base 'Plync::Stateful';

sub id        { @_ > 1 ? $_[0]->{id}        = $_[1] : $_[0]->{id} }
sub parent_id { @_ > 1 ? $_[0]->{parent_id} = $_[1] : $_[0]->{parent_id} }
sub class     { @_ > 1 ? $_[0]->{class}     = $_[1] : $_[0]->{class} }
sub type      { @_ > 1 ? $_[0]->{type}      = $_[1] : $_[0]->{type} }

sub display_name {
    @_ > 1 ? $_[0]->{display_name} = $_[1] : $_[0]->{display_name};
}

1;
