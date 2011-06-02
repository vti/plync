package Plync::Folders;

use strict;
use warnings;

use base 'Plync::Stateful';

my $DB;

sub new {
    my $self = shift->SUPER::new(@_);

    $self->{folders} ||= [];

    return $self;
}

sub add {
    my $self = shift;
    my ($folder) = @_;

    push @{$self->{folders}}, $folder;

    return $self;
}

sub load {
    my $class = shift;

    return $DB->{'root'};
}

sub save {
    my $self = shift;

    $DB->{'root'} = $self;

    return $self;
}

sub load_folder {
    my $self = shift;
    my ($id) = @_;

    foreach my $folder (@{$self->{folders}}) {
        if ($folder->id eq $id) {
            return $folder;
        }
    }

    return;
}

sub folders  { @_ > 1 ? $_[0]->{folders}  = $_[1] : $_[0]->{folders} }

1;
