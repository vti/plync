package Plync::Command::Ping::Response;

use strict;
use warnings;

use base 'Plync::Command::BaseResponse';

use XML::LibXML;
use Plync::Utils qw(to_xml);

sub to_string {
    my $self = shift;

    $self->{status} ||= 1;

    my $dom = XML::LibXML::Document->createDocument('1.0', 'utf-8');
    my $root = $dom->createElementNS('Ping:', 'Ping');
    $dom->setDocumentElement($root);

    my $status = $dom->createElement('Status');
    $status->appendText($self->{status});
    $root->appendChild($status);

    if ($self->{status} == 2) {
        my $folders = $root->addNewChild('', 'Folders');
        foreach my $name (@{$self->{folders}}) {
            $folders->addNewChild('', 'Folder')->appendText($name);
        }
    }
    elsif ($self->{status} == 5) {
        $root->addNewChild('', 'HeartbeatInterval')
          ->appendText($self->{interval});
    }
    elsif ($self->{status} == 6) {
        $root->addNewChild('', 'MaxFolders')
          ->appendText($self->{max_folders});
    }

    return $dom->toString;
}

1;
