package Plync::Config;

use strict;
use warnings;

use YAML::Tiny;

our $CONFIG;

sub load {
    my $class = shift;
    my ($path) = @_;

    my $yaml = YAML::Tiny->new;

    $yaml = YAML::Tiny->read($path) or die $!;

    $CONFIG = $yaml;
}

sub get { $CONFIG }

1;
