package Plync::Device;

use strict;
use warnings;

use Async::MergePoint;

sub new {
    my $class = shift;

    my $self = {@_};
    bless $self, $class;

    return $self;
}

sub id   { $_[0]->{id} }
sub user { $_[0]->{user} }

sub backends   { $_[0]->{backends} }
sub folder_set { @_ > 1 ? $_[0]->{folder_set} = $_[1] : $_[0]->{folder_set} }

sub backend {
    my $self = shift;
    my ($class) = @_;

    die 'Class is required' unless $class;

    $class = lc $class;

    my $backend = $self->backends->{$class};

    die "No backend registered for '$class'" unless defined $backend;

    return $backend;
}

sub fetch_folders {
    my $self = shift;
    my ($cb) = @_;

    delete $self->{folder_set};

    my $backends = $self->backends;

    my @types = keys %$backends;

    my $mp = Async::MergePoint->new(needs => [@types]);

    for my $type (@types) {
        $self->backend($type)->fetch_folders(
            sub {
                my $backend = shift;
                my ($folder_set) = @_;

                if (my $set = $self->{folder_set}) {
                    $set->add_set($folder_set);
                }
                else {
                    $self->{folder_set} = $folder_set;
                }

                $mp->done($type);
            }
        );
    }

    $mp->close(
        on_finished => sub {
            $cb->($self, $self->{folder_set});
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

    $self->backend($folder->class)->fetch_folder(
        $folder->id => sub {
            my $backend = shift;
            my ($folder) = @_;

            return $cb->($self, $folder);
        }
    );
}

sub fetch_item {
    my $self = shift;
    my ($folder_id, $item_id, $cb) = @_;

    my $folder = $self->folder_set->get($folder_id);
    return $cb->($self) unless $folder;

    $self->backend($folder->class)->fetch_item(
        $folder => $item_id => sub {
            my $backend = shift;
            my ($item) = @_;

            $cb->($self, $item);
        }
    );
}

sub watch {
    my $self = shift;
    my ($folders, $cb) = @_;

    my $class = $folders->[0]->{class};

    # TODO handle different classes

    $self->backend($class)->watch(
        $folders => sub {
            my $backend = shift;
            my ($folders) = @_;

            $cb->($self, $folders);
        }
    );
}

1;
