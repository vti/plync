package Plync::Folder;

use strict;
use warnings;

use Digest::MD5 ();

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
    my $class = shift;

    my $self = {@_};
    bless $self, $class;

    die "Missing param 'class'" unless defined $self->{class};

    if ($self->{class} eq 'Email') {
        die "Missign param 'type'" unless defined $self->{type};
        $self->{type} = $FOLDER_TYPES{$self->{type}};
    }
    else {
        $self->{type} = $FOLDER_TYPES{$self->{class}};
    }

    for (qw(id type display_name)) {
        die "Missing param '$_'" unless defined $self->{$_};
    }

    $self->{parent_id} = 0 unless defined $self->{parent_id};

    $self->{items} ||= [];

    return $self;
}

sub id        { @_ > 1 ? $_[0]->{id}        = $_[1] : $_[0]->{id} }
sub parent_id { @_ > 1 ? $_[0]->{parent_id} = $_[1] : $_[0]->{parent_id} }
sub class     { @_ > 1 ? $_[0]->{class}     = $_[1] : $_[0]->{class} }
sub type      { @_ > 1 ? $_[0]->{type}      = $_[1] : $_[0]->{type} }

sub display_name {
    @_ > 1 ? $_[0]->{display_name} = $_[1] : $_[0]->{display_name};
}

sub add_item {
    my $self = shift;
    my ($item) = @_;

    push @{$self->{items}}, $item;
}

sub items { $_[0]->{items} }

sub checksum {
    my $self = shift;

    my $ctx = Digest::MD5->new;

    $ctx->add($self->id);
    $ctx->add($self->parent_id);
    $ctx->add($self->class);
    $ctx->add($self->type);
    $ctx->add($self->display_name);

    return $ctx->hexdigest;
}

1;
