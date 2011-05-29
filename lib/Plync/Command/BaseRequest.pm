package Plync::Command::BaseRequest;

use strict;
use warnings;

use Class::Load ();
use Scalar::Util qw(blessed);
use Try::Tiny;
use XML::LibXML;

sub parse {
    my $class = shift;
    my ($dom) = @_;

    unless (blessed $dom) {
        $dom =
          XML::LibXML->new(clean_namespaces => 1, no_network => 1)
          ->parse_string($dom);
    }

    #return unless $class->_is_valid($dom);

    return $class->_parse($dom);
}

sub new_response {
    my $self = shift;

    my $class = ref($self);
    $class =~ s/::Request$//;
    my $response_class = "$class\::Response";

    Class::Load::load_class($response_class);

    return $response_class->new(@_);
}

sub _is_valid {
    my $class = shift;
    my ($dom) = @_;

    my ($command) = $class =~ m/::(\w+)$/;
    $command = lc $command;

    return try {
        my $schema =XML::LibXML::Schema->new(location => "schemas/ping-$command.xsd");
        $schema->validate($dom);
        return 1;
    }
    catch {
        return 0;
    };
}

1;
