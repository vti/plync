package Plync::Dispatcher;

use strict;
use warnings;

use Class::Load ();
use Scalar::Util qw(blessed);
use Try::Tiny;
use XML::XPath;

sub dispatch {
    my $class = shift;
    my ($xml) = @_;

    my $xpath = XML::XPath->new(xml => $xml);

    my $command = try { $xpath->find('name(*)') } catch {};
    return $class->_dispatch_error(400, 'Malformed XML')
      unless defined $command;

    my $command_class = "Plync::Command::$command";

    try {
        Class::Load::load_class($command_class);

        return $class->_dispatch($command_class, $xpath);
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
    my ($command_class, $xpath) = @_;

    my $req_class = "$command_class\::Request";

    Class::Load::load_class($req_class);

    my $req = try { $req_class->parse($xpath) };
    return $class->_dispatch_error(400) unless $req;

    my $res = $command_class->new(req => $req)->dispatch;
    return $res if ref $res eq 'ARRAY';

    return $res->to_string if blessed $res;

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
