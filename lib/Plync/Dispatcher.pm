package Plync::Dispatcher;

use strict;
use warnings;

use Class::Load ();
use Scalar::Util qw(blessed);
use Try::Tiny;
use XML::LibXML;

sub dispatch {
    my $class = shift;
    my ($dom) = @_;

    unless (blessed $dom) {
        $dom = try { XML::LibXML->new(no_network => 1)->parse_string($dom) };
        return $class->_dispatch_error(400, 'Malformed XML')
          unless defined $dom;
    }

    my $command = try { $dom->findvalue('name(*)') } catch {};
    return $class->_dispatch_error(400, 'Malformed XML')
      unless defined $command;

    my $command_class = "Plync::Command::$command";

    try {
        Class::Load::load_class($command_class);

        return $class->_dispatch($command_class, $dom);
    }
    catch {
        $command_class =~ s{::}{/}g;
        $command_class .= '.pm';

        die $_ unless $_ =~ m/^Can't locate $command_class in \@INC/;

        return $class->_dispatch_error(501, 'Not supported');
    };
}

sub _dispatch {
    my $class = shift;
    my ($command_class, $dom) = @_;

    my $res = $command_class->dispatch($dom);
    return $class->_dispatch_error(400, 'Bad request') unless defined $res;

    return $res;
}

sub _dispatch_error {
    my $class = shift;
    my ($status, $message) = @_;

    $message = 'Bad request' unless defined $message;

    return [
        $status,
        [   'Content-Type'   => 'plain/text',
            'Content-Length' => length($message)
        ],
        [$message]
    ];
}

1;
