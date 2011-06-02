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

sub build {
    my $self = shift;

    my $ns = 'AirSync:';

    my $dom = XML::LibXML::Document->createDocument('1.0', 'UTF-8');
    my $root = $dom->createElementNS($ns, 'Sync');
    $dom->setDocumentElement($root);

    if (defined $self->{status}) {
        $root->addNewChild($ns, 'Status')->appendText($self->{status});
    }

    if ($self->{collections} && @{$self->{collections}}) {
        my $collections = $root->addNewChild($ns, 'Collections');

        foreach my $collection (@{$self->{collections}}) {
            my $node = $collections->addNewChild($ns, 'Collection');

            if (defined $collection->{class}) {
                $node->addNewChild($ns, 'Class')
                  ->appendText($collection->{class});
            }

            $node->addNewChild($ns, 'SyncKey')
              ->appendText($collection->{sync_key});
            $node->addNewChild($ns, 'CollectionId')
              ->appendText($collection->{collection_id});
            $node->addNewChild($ns, 'Status')
              ->appendText($collection->{status});

            if ($collection->{commands} && @{$collection->{commands}}) {
                my $commands = $node->addNewChild($ns, 'Commands');

                for (my $i = 0; $i < @{$collection->{commands}}; $i += 2) {
                    my $command = $collection->{commands}->[$i];
                    my $value   = $collection->{commands}->[$i + 1];

                    if ($command eq 'add') {
                        my $add = $commands->addNewChild($ns, 'Add');
                        $add->addNewChild($ns, 'ServerId')
                          ->appendText($value->{server_id});
                        my $data = $add->addNewChild($ns, 'ApplicationData');
                        $value->{application_data}->appendTo($dom, $data);
                    }
                }
            }
        }
    }

    return $dom;
}

1;
