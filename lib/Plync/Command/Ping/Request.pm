package Plync::Command::Ping::Request;

use strict;
use warnings;

use base 'Plync::Command::BaseRequest';

use XML::LibXML::XPathContext;

sub _parse {
    my $class = shift;
    my ($dom) = @_;

    my $xpc = XML::LibXML::XPathContext->new($dom->documentElement);
    $xpc->registerNs('ping', 'Ping:');

    my $interval = $xpc->findvalue('//ping:HeartbeatInterval[1]');
    return unless $interval =~ m/^\d+$/;

    my @folders;

    foreach my $folder ($xpc->findnodes('//ping:Folders/ping:Folder')->get_nodelist) {
        my $id    = $xpc->findvalue('./ping:Id',    $folder);
        my $class = $xpc->findvalue('./ping:Class', $folder);

        push @folders,
          { id    => "$id",
            class => "$class"
          };
    }

    bless {
        interval => $interval,
        folders  => \@folders
    }, $class;
}

sub interval { shift->{interval} }
sub folders  { shift->{folders} }

1;
