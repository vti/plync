package Plync::Device;

use strict;
use warnings;

use Plync::FolderSetSyncable;

sub new {
    my $class = shift;

    my $self = {@_};
    bless $self, $class;

    return $self;
}

sub id   { $_[0]->{id} }
sub user { $_[0]->{user} }

sub backend    { $_[0]->{backend} }
sub folder_set { $_[0]->{folder_set} }

sub fetch_folders {
    my $self = shift;
    my ($cb) = @_;

    $self->backend->fetch_folders(
        sub {
            my $backend = shift;
            my ($folder_set) = @_;

            $self->{folder_set} = $self->_build_folder_set($folder_set);

            foreach my $folder (@{$folder_set->list}) {
                $folder_set->delete($folder->id);
                $self->{folder_set}->add($folder);
            }

            return $cb->($self, $self->{folder_set});
        }
    );
}

sub fetch_folder {
    my $self   = shift;
    my $id     = shift;
    my $cb     = pop;
    my %params = @_;

    return $cb->($self) unless $self->folder_set;

    my $folder = $self->folder_set->get($id);
    return $cb->($self) unless $folder;

    if (!$params{items}) {
        return $cb->($self, $folder);
    }

    $self->backend->fetch_folder(
        $folder => sub {
            my $backend = shift;
            my ($folder) = @_;

            return $cb->($self, $folder);
        }
    );
}

sub fetch_folder_item {
    my $self = shift;
    my ($folder, $item_id, $cb) = @_;

    $self->backend->fetch_folder_item(
        $folder, $item_id,
        sub {
            my $backend = shift;
            my ($item) = @_;

            $cb->($self, $item);
        }
    );
}

sub start_watch_folders {
    my $self = shift;
    my ($folders, $cb) = @_;

}

sub stop_watch_folders {
    my $self = shift;
    my ($folders, $cb) = @_;

    $cb->();
}

sub _build_folder_set {
    my $self = shift;

    return Plync::FolderSetSyncable->new(@_);
}

1;
