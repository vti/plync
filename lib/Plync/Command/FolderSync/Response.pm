package Plync::Command::FolderSync::Response;

use strict;
use warnings;

use base 'Plync::Command::BaseResponse';

use XML::LibXML;

sub new {
    my $self = shift->SUPER::new(@_);

    $self->{folders} ||= [];
    $self->{status} = 1 unless defined $self->{status};

    return $self;
}

sub add_folder {
    my $self   = shift;
    my %folder = @_;

    push @{$self->{folders}}, {%folder};
}

sub build {
    my $self = shift;

    my $ns = 'FolderHierarchy:';

    my $dom = XML::LibXML::Document->createDocument('1.0', 'utf-8');
    my $root = $dom->createElementNS($ns, 'FolderSync');
    $dom->setDocumentElement($root);

    $root->addNewChild($ns, 'Status')->appendText($self->{status});

    if (defined $self->{sync_key}) {
        $root->addNewChild($ns, 'SyncKey')->appendText($self->{sync_key});
    }

    if (@{$self->{folders}}) {
        my $changes = $root->addNewChild($ns, 'Changes');
        $changes->addNewChild($ns, 'Count')
          ->appendText(scalar @{$self->{folders}});

        foreach my $folder (@{$self->{folders}}) {
            my $add = $changes->addNewChild($ns, 'Add');

            $add->addNewChild($ns, 'ServerId')->appendText($folder->{server_id});
            $add->addNewChild($ns, 'ParentId')
              ->appendText($folder->{parent_id} || 0);
            $add->addNewChild($ns, 'DisplayName')
              ->appendText($folder->{display_name});
            $add->addNewChild($ns, 'Type')->appendText($folder->{type});
        }
    }

    return $dom;
}

sub status   { @_ > 1 ? $_[0]->{status}   = $_[1] : $_[0]->{status} }
sub sync_key { @_ > 1 ? $_[0]->{sync_key} = $_[1] : $_[0]->{sync_key} }

1;
