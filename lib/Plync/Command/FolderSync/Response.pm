package Plync::Command::FolderSync::Response;

use strict;
use warnings;

use base 'Plync::Command::BaseResponse';

use XML::LibXML;

sub build {
    my $self = shift;

    my $dom = XML::LibXML::Document->createDocument('1.0', 'utf-8');
    my $root = $dom->createElementNS('FolderHierarchy:', 'FolderSync');
    $dom->setDocumentElement($root);

    $root->addNewChild('', 'Status')->appendText($self->{status});
    $root->addNewChild('', 'SyncKey')->appendText($self->{sync_key});

    my $changes = $root->addNewChild('', 'Changes');
    $changes->addNewChild('', 'Count')->appendText(scalar @{$self->{changes}});

    foreach my $change (@{$self->{changes}}) {
        my $add = $changes->addNewChild('', 'Add');

        $add->addNewChild('', 'ServerId')->appendText($change->{server_id});
        $add->addNewChild('', 'ParentId')->appendText($change->{parent_id});
        $add->addNewChild('', 'DisplayName')->appendText($change->{display_name});
        $add->addNewChild('', 'Type')->appendText($change->{type});
    }

    return $dom;
}

1;
