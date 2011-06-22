package Plync::Command::Ping::Request;

use strict;
use warnings;

use base 'Plync::Command::BaseRequest';

use XML::LibXML::XPathContext;

sub new {
    my $self = shift->SUPER::new(@_);

    $self->{min_interval} ||= 60;
    $self->{max_interval} ||= 500;

    $self->{max_folders} ||= 5;

    return $self;
}

sub _parse {
    my $self = shift;
    my ($dom) = @_;

    my $xpc = XML::LibXML::XPathContext->new($dom->documentElement);
    $xpc->registerNs('ping', 'Ping:');

    my $interval = $xpc->findvalue('//ping:HeartbeatInterval[1]');
    return unless $interval =~ m/^\d+(\.\d+)?$/;

    my @folders;

    foreach
      my $folder ($xpc->findnodes('//ping:Folders/ping:Folder')->get_nodelist)
    {
        my $id    = $xpc->findvalue('./ping:Id',    $folder);
        my $class = $xpc->findvalue('./ping:Class', $folder);

        push @folders,
          { id    => "$id",
            class => "$class"
          };
    }

    $self->{interval} = $interval;
    $self->{folders}  = \@folders;

    $self->_validate;

    return $self;
}

sub interval { @_ > 1 ? $_[0]->{interval} = $_[1] : $_[0]->{interval} }
sub folders { shift->{folders} }

sub error { @_ > 1 ? $_[0]->{error} = $_[1] : $_[0]->{error} }
sub max_folders { $_[0]->{max_folders} }

sub _validate {
    my $self = shift;

    if ($self->interval < $self->{min_interval}) {
        $self->error(5);
        $self->interval($self->{min_interval});
        return $self;
    }

    if ($self->interval > $self->{max_interval}) {
        $self->error(5);
        $self->interval($self->{max_interval});
        return $self;
    }

    my $folders = $self->folders;
    if (@$folders > $self->{max_folders}) {
        $self->error(6);
    }
}

1;
