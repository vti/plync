package Plync::Command::Sync::Response;

use strict;
use warnings;

use base 'Plync::Command::BaseResponse';

use XML::LibXML;

sub to_string {
    my $self = shift;

    my $dom = XML::LibXML::Document->createDocument('1.0', 'utf-8');
    my $root = $dom->createElementNS('AirSync:', 'Sync');
    $dom->setDocumentElement($root);

    my $collections = $root->addNewChild('', 'Collections');

    foreach my $collection (@{$self->{collections}}) {
        my $node = $collections->addNewChild('', 'Collection');

        $node->addNewChild('', 'Class')->appendText($collection->{class});
        $node->addNewChild('', 'SyncKey')
          ->appendText($collection->{sync_key});
        $node->addNewChild('', 'CollectionId')
          ->appendText($collection->{collection_id});
        $node->addNewChild('', 'Commands')->appendText('123');
    }

    return $dom->toString();
}

1;
