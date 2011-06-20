package Plync::Folder;

use strict;
use warnings;

use base 'Plync::Stateful';

our %FOLDER_TYPES = (
    Folder   => 1,
    Inbox    => 2,
    Drafts   => 3,
    Trash    => 4,
    Sent     => 5,
    Outbox   => 6,
    Tasks    => 7,
    Calendar => 8,
    Contacts => 9,
    Notes    => 10,
    Journal  => 11,

    #User-created Mail folder               => 12,
    #User-created Calendar folder           => 13,
    #User-created Contacts folder           => 14,
    #User-created Tasks folder              => 15,
    #User-created journal folder            => 16,
    #User-created Notes folder              => 17,

    Unknown => 18,
    Cache   => 19,
);

sub new {
    my $self = shift->SUPER::new(@_);

    if ($self->{class} eq 'Email') {
        die "Missign param 'type'" unless defined $self->{type};
        $self->{type} = $FOLDER_TYPES{$self->{type}};
    }
    else {
        $self->{type} = $FOLDER_TYPES{$self->{class}};
    }

    for (qw(id class type display_name)) {
        die "Missing param '$_'" unless defined $self->{$_};
    }

    $self->{parent_id} = 0 unless defined $self->{parent_id};

    return $self;
}

sub id        { @_ > 1 ? $_[0]->{id}        = $_[1] : $_[0]->{id} }
sub parent_id { @_ > 1 ? $_[0]->{parent_id} = $_[1] : $_[0]->{parent_id} }
sub class     { @_ > 1 ? $_[0]->{class}     = $_[1] : $_[0]->{class} }
sub type      { @_ > 1 ? $_[0]->{type}      = $_[1] : $_[0]->{type} }

sub display_name {
    @_ > 1 ? $_[0]->{display_name} = $_[1] : $_[0]->{display_name};
}

1;
