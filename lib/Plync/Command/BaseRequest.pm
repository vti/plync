package Plync::Command::BaseRequest;

use strict;
use warnings;

use Class::Load ();
use XML::XPath;
use Scalar::Util qw(blessed);

sub parse {
    my $class = shift;
    my ($xml) = @_;

    my $xpath = blessed $xml ? $xml : XML::XPath->new(xml => $xml);

    return $class->_parse($xpath);
}

sub new_response {
    my $self = shift;

    my $class = ref($self);
    $class =~ s/::Request$//;
    my $response_class = "$class\::Response";

    Class::Load::load_class($response_class);

    return $response_class->new(@_);
}

1;
