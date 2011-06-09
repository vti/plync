package Plync::Command::FolderSync::Request;

use strict;
use warnings;

use base 'Plync::Command::BaseRequest';

sub _parse {
    my $self = shift;
    my ($dom) = @_;

    my $xpc = XML::LibXML::XPathContext->new($dom->documentElement);
    $xpc->registerNs('fh', 'FolderHierarchy:');

    my $sync_key = $xpc->findvalue('//fh:SyncKey[1]');
    unless (defined $sync_key && $sync_key ne '') {
        $self->{error} = 10;
        return;
    }

    $self->{sync_key} = $sync_key;
}

sub error { shift->{error} }

sub sync_key { shift->{sync_key} }

1;
