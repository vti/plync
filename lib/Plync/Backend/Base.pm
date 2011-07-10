package Plync::Backend::Base;

use strict;
use warnings;

use Plync::Folder;
use Plync::FolderSet;
use Plync::Backend::Watcher;

sub new {
    my $class = shift;

    my $self = {@_};
    bless $self, $class;

    return $self;
}

sub user { $_[0]->{user} }

sub fetch_folder  { die 'not implemented' }
sub fetch_folders { die 'not implemented' }
sub fetch_item    { die 'not implemented' }
sub watch         { die 'not implemented' }

sub _build_folder_set {
    my $self = shift;

    return Plync::FolderSet->new(@_);
}

sub _build_folder {
    my $self = shift;

    return Plync::Folder->new(@_);
}

sub _build_watcher {
    my $self = shift;

    return Plync::Backend::Watcher->new(@_);
}

1;
