package Plync::Command::Sync::Request;

use strict;
use warnings;

use base 'Plync::Command::BaseRequest';

sub _parse {
    my $class = shift;
    my ($xpath) = @_;

    my @collections;

    foreach
      my $collection ($xpath->find('//Collections/Collection')->get_nodelist)
    {
        my $collection_id    = $xpath->find('./CollectionId',   $collection);
        my $sync_key         = $xpath->find('./SyncKey',        $collection);
        my $class            = $xpath->find('./Class',          $collection);
        my $deletes_as_moves = !!$xpath->find('./DeletesAsMoves', $collection);
        my $get_changes      = !!$xpath->find('./GetChanges',     $collection);

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
