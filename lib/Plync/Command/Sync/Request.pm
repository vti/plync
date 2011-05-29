package Plync::Command::Sync::Request;

use strict;
use warnings;

use base 'Plync::Command::BaseRequest';

sub _parse {
    my $class = shift;
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

        my @options;

        push @collections,
          { collection_id    => "$collection_id",
            sync_key         => "$sync_key",
            class            => "$class",
            deletes_as_moves => "$deletes_as_moves",
            get_changes      => "$get_changes",
            options          => \@options
          };
    }

    return bless {collections => \@collections}, $class;
}

sub collections { shift->{collections} }

1;
