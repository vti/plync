package Plync::Folder;

use strict;
use warnings;

use Plync::Folder::Email;

sub new {
    my $class = shift;
    my %args = @_;

    if ($args{class} eq 'Email') {
        return Plync::Folder::Email->new(@_);
    }

    return;
}

1;
