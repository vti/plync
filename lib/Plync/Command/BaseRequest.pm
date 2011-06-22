package Plync::Command::BaseRequest;

use strict;
use warnings;

use Class::Load ();
use Scalar::Util qw(blessed);
use XML::LibXML;

sub new {
    my $class = shift;

    my $self = {@_};
    bless $self, $class;

    return $self;
}

sub parse {
    my $self = shift;
    my ($dom) = @_;

    unless (blessed $dom) {
        $dom =
          XML::LibXML->new(no_blanks => 1, clean_namespaces => 1, no_network => 1)
          ->parse_string($dom);
    }

    $self->_parse($dom);

    return $self;
}

sub new_response {
    my $self = shift;

    my $class = ref($self);
    $class =~ s/::Request$//
      or die "Can't guess response class from '$class'";
    my $response_class = "$class\::Response";

    Class::Load::load_class($response_class);

    return $response_class->new(@_);
}

1;
