package Plync::Backend::Base;

use strict;
use warnings;

sub new {
    my $class = shift;

    my $self = {@_};
    bless $self, $class;

    return $self;
}

sub user { $_[0]->{user} }

sub fetch_folder {
}

sub fetch_folders {
}

1;
