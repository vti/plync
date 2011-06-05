package Plync::Command::Sync::Response;

use strict;
use warnings;

use base 'Plync::Command::BaseResponse';

use XML::LibXML;

sub add_collection {
    my $self = shift;

    push @{$self->{collections}}, {@_};
}

sub status { @_ > 1 ? $_[0]->{status} = $_[1] : $_[0]->{status} }

sub ns {'AirSync:'}

sub document {
    my $self = shift;

    $self->{document} ||= XML::LibXML::Document->createDocument('1.0', 'UTF-8');

    return $self->{document};
}

sub build {
    my $self = shift;

    my $ns = $self->ns;

    my $dom = $self->document;
    my $root = $dom->createElementNS($ns, 'Sync');
    $dom->setDocumentElement($root);

    if (defined $self->{status}) {
        $root->addNewChild($ns, 'Status')->appendText($self->{status});
    }

    if ($self->{collections} && @{$self->{collections}}) {
        my $collections = $root->addNewChild($ns, 'Collections');

        foreach my $collection (@{$self->{collections}}) {
            my $node = $collections->addNewChild($ns, 'Collection');

            $node->addNewChild($ns, 'SyncKey')
              ->appendText($collection->{sync_key});
            $node->addNewChild($ns, 'CollectionId')
              ->appendText($collection->{collection_id});
            $node->addNewChild($ns, 'Status')
              ->appendText($collection->{status});

            if (defined $collection->{class}) {
                $node->addNewChild($ns, 'Class')
                  ->appendText($collection->{class});
            }

            $self->_build_collection_commands($node, $collection);

            $self->_build_collection_responses($node, $collection);
        }
    }

    return $dom;
}

sub _build_collection_commands {
    my $self = shift;
    my ($node, $collection) = @_;

    return unless $collection->{commands} && @{$collection->{commands}};

    my $ns = $self->ns;

    my $commands = $node->addNewChild($ns, 'Commands');

    for (my $i = 0; $i < @{$collection->{commands}}; $i += 2) {
        my $command = $collection->{commands}->[$i];
        my $value   = $collection->{commands}->[$i + 1];

        if ($command eq 'add') {
            my $add = $commands->addNewChild($ns, 'Add');
            $add->addNewChild($ns, 'ServerId')
              ->appendText($value->{server_id});

            my $data = $add->addNewChild($ns, 'ApplicationData');
            $value->{application_data}->appendTo($self->document, $data);
        }
    }
}

sub _build_collection_responses {
    my $self = shift;
    my ($node, $collection) = @_;

    return unless $collection->{responses} && @{$collection->{responses}};

    my $ns = $self->ns;

    my $responses = $node->addNewChild($ns, 'Responses');

    for (my $i = 0; $i < @{$collection->{responses}}; $i += 2) {
        my $response = $collection->{responses}->[$i];
        my $value    = $collection->{responses}->[$i + 1];

        if ($response eq 'fetch') {
            my $fetch = $responses->addNewChild($ns, 'Fetch');

            $fetch->addNewChild($ns, 'ServerId')
              ->appendText($value->{server_id});
            $fetch->addNewChild($ns, 'Status')->appendText($value->{status});

            my $data = $fetch->addNewChild($ns, 'ApplicationData');
            $value->{application_data}->appendTo($self->document, $data);
        }
        elsif ($response eq 'change') {
            my $change = $responses->addNewChild($ns, 'Change');

            $change->addNewChild($ns, 'ServerId')
              ->appendText($value->{server_id});
            $change->addNewChild($ns, 'Status')->appendText($value->{status});
        }
    }
}

1;
