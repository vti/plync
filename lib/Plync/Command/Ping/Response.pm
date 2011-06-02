package Plync::Command::Ping::Response;

use strict;
use warnings;

use base 'Plync::Command::BaseResponse';

use XML::LibXML;

sub build {
    my $self = shift;

    $self->{status} ||= 1;

    my $ns = 'Ping:';

    my $dom = XML::LibXML::Document->createDocument('1.0', 'utf-8');
    my $root = $dom->createElementNS($ns, 'Ping');
    $dom->setDocumentElement($root);

    my $status = $dom->createElement('Status');
    $status->appendText($self->{status});
    $root->appendChild($status);

    if ($self->{status} == 2) {
        my $folders = $root->addNewChild($ns, 'Folders');
        foreach my $name (@{$self->{folders}}) {
            $folders->addNewChild($ns, 'Folder')->appendText($name);
        }
    }
    elsif ($self->{status} == 5) {
        $root->addNewChild($ns, 'HeartbeatInterval')
          ->appendText($self->{interval});
    }
    elsif ($self->{status} == 6) {
        $root->addNewChild($ns, 'MaxFolders')
          ->appendText($self->{max_folders});
    }

    return $dom;
}

1;
