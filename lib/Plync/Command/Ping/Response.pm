package Plync::Command::Ping::Response;

use strict;
use warnings;

use base 'Plync::Command::BaseResponse';

use XML::LibXML;

sub new {
    my $self = shift->SUPER::new(@_);

    $self->{folders} ||= [];

    return $self;
}

sub build {
    my $self = shift;

    $self->{status} ||= 1;

    my $ns = 'Ping:';

    my $dom = XML::LibXML::Document->createDocument('1.0', 'utf-8');
    my $root = $dom->createElementNS($ns, 'Ping');
    $dom->setDocumentElement($root);

    my $status = $dom->createElementNS($ns, 'Status');
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

sub add_folder {
    my $self = shift;
    my ($id) = @_;

    push @{$self->{folders}}, $id;

    return $self;
}

sub status   { @_ > 1 ? $_[0]->{status}   = $_[1] : $_[0]->{status} }
sub interval { @_ > 1 ? $_[0]->{interval} = $_[1] : $_[0]->{interval} }

sub max_folders {
    @_ > 1 ? $_[0]->{max_folders} = $_[1] : $_[0]->{max_folders};
}

1;
