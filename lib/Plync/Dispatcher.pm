package Plync::Dispatcher;

use strict;
use warnings;

use Plync::HTTPException;

use Class::Load ();
use Scalar::Util qw(blessed);
use Try::Tiny;
use XML::LibXML;

sub new {
    my $class = shift;

    my $self = {@_};
    bless $self, $class;

    return $self;
}

sub dispatch {
    my $self = shift;
    my ($command, $dom) = @_;

    my $command_class = "Plync::Command::$command";

    return try {
        Class::Load::load_class($command_class);

        return $self->_dispatch($command_class, $dom);
    }
    catch {
        $command_class =~ s{::}{/}g;
        $command_class .= '.pm';

        die $_ unless $_ =~ m/^Can't locate $command_class in \@INC/;

        Plync::HTTPException->throw(501, message => 'Not supported');
    };
}

sub _dispatch {
    my $self = shift;
    my ($command_class, $dom) = @_;

    my $command = $command_class->new(device => $self->{device});

    return $command->dispatch($dom) or Plync::HTTPException->throw(400);
}

sub _parse_command {
    my $self = shift;
    my ($dom) = @_;

    $dom = $self->_parse_xml($dom) unless blessed $dom;

    return try {
        $dom->findvalue('name(*)');
    }
    catch {
        Plync::HTTPException->throw(400, message => 'Malformed XML');
    };
}

sub _parse_xml {
    my $self = shift;
    my ($xml) = @_;

    return try {
        XML::LibXML->new(no_network => 1)->parse_string($xml);
    }
    catch {
        Plync::HTTPException->throw(400, message => 'Malformed XML');
    };
}

1;
