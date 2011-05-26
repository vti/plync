package Plync::Command::Ping::Request;

use strict;
use warnings;

use base 'Plync::Command::BaseRequest';

sub _parse {
    my $class = shift;
    my ($xpath) = @_;

    my $interval = $xpath->getNodeText('//HeartbeatInterval[1]');
    return unless $interval =~ m/^\d+$/;

    my @folders;

    foreach my $folder ($xpath->find('//Folders/Folder')->get_nodelist) {
        my $id    = $xpath->find('./Id',    $folder);
        my $class = $xpath->find('./Class', $folder);

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
