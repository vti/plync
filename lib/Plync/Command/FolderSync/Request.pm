package Plync::Command::FolderSync::Request;

use strict;
use warnings;

use base 'Plync::Command::BaseRequest';

sub _parse {
    my $class = shift;
    my ($xpath) = @_;

    my $sync_key = $xpath->getNodeText('//SyncKey[1]');
    return unless $sync_key =~ m/^\d+$/;

    return bless {sync_key => $sync_key}, $class;
}

sub sync_key { shift->{sync_key} }

1;
