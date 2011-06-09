package Plync::Command::Sync::Request;

use strict;
use warnings;

use base 'Plync::Command::BaseRequest';

use String::CamelCase 'decamelize';

sub _parse {
    my $self = shift;
    my ($dom) = @_;

    my $xpc = XML::LibXML::XPathContext->new($dom->documentElement);
    $xpc->registerNs('as', 'AirSync:');

    my @collections;

    foreach
      my $collection ($xpc->findnodes('//as:Collections/as:Collection'))
    {
        my $collection_id    = $xpc->find('./as:CollectionId',   $collection);
        my $sync_key         = $xpc->find('./as:SyncKey',        $collection);
        my $class            = $xpc->find('./as:Class',          $collection);
        my $deletes_as_moves = !!$xpc->find('./as:DeletesAsMoves', $collection);
        my $get_changes      = !!$xpc->find('./as:GetChanges',     $collection);

        my $hashref = {
            collection_id    => "$collection_id",
            sync_key         => "$sync_key",
            class            => "$class",
            deletes_as_moves => "$deletes_as_moves"
        };

        if ($get_changes) {
            $hashref->{get_changes} = 1;
        }

        foreach my $option ($xpc->findnodes('./as:Options/*', $collection)) {
            $hashref->{options}->{decamelize($option->nodeName)} = $option->textContent;
        }

        foreach my $command ($xpc->findnodes('./as:Commands/*', $collection)) {
            push @{$hashref->{commands}},  decamelize($command->nodeName);

            my $value = {};

            foreach my $values ($command->childNodes) {
                $value->{decamelize($values->nodeName)} = $values->textContent;
            }

            push @{$hashref->{commands}}, $value;
            #$hashref->{commands}->{decamelize($command->nodeName)} = $command->textContent;
        }

        push @collections, $hashref;
    }

    $self->{collections} = \@collections;
}

sub collections { shift->{collections} }

1;
