package Plync::FolderSet;

use strict;
use warnings;

sub new {
    my $class = shift;

    my $self = {@_};
    bless $self, $class;

    $self->{folders} = [];
    $self->{set} = {};

    return $self;
}

sub add {
    my $self = shift;
    my ($folder) = @_;

    $self->{set}->{$folder->id} = $folder;
    push @{$self->{folders}}, $self->{set}->{$folder->id};

    return $self;
}

sub delete {
    my $self = shift;
    my ($id) = @_;

    my @list;
    foreach my $item (@{$self->list}) {
        push @list, $item unless $item->id == $id;
    }

    $self->{folders} = [@list];

    return delete $self->{set}->{$id};
}

sub update {
    my $self = shift;
    my ($id, $new_folder) = @_;

    foreach my $item (@{$self->list}) {
        if ($item->id == $id) {
            $item = $new_folder;
            last;
        }
    }

    $self->{set}->{$id} = $new_folder;

    return $self;
}

sub get {
    my $self = shift;
    my ($id) = @_;

    return $self->{set}->{$id};
}

sub list {
    my $self = shift;

    return $self->{folders};
}

1;
