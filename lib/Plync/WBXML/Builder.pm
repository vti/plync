package Plync::WBXML::Builder;

use strict;
use warnings;

use base 'Plync::WBXML::Base';

use Plync::WBXML::Constants;
use Plync::WBXML::Util qw(to_mb_u_int32);
use I18N::Charset qw(charset_name_to_mib);

use XML::LibXML;

sub build {
    my $self = shift;
    my ($xml) = @_;

    $self->{version}  ||= 3;
    $self->{publicid} ||= 1;
    $self->{charset}  ||= 'UTF-8';

    $self->{page} = 0;
    $self->{buffer} = [];

    $self->_push($self->{version});
    $self->_push($self->{publicid});
    $self->_push(charset_name_to_mib($self->{charset}));
    $self->_push(0);

    my $parser = XML::LibXML->new;
    $parser->set_options(no_blanks => 1);
    $parser->expand_entities(0);
    my $dom = $parser->parse_string($xml);

    $self->_build_nodes($dom->childNodes);

    return $self;
}

sub to_wbxml {
    my $self = shift;

    return join '', @{$self->{buffer}};
}

sub _build_nodes {
    my $self     = shift;
    my @children = @_;

    foreach my $node (@children) {
        next
          unless $node->nodeType == XML_DTD_NODE
              || $node->nodeType == XML_ELEMENT_NODE
              || $node->nodeType == XML_TEXT_NODE
              || $node->nodeType == XML_ENTITY_REF_NODE;

        if ($node->nodeType == XML_DTD_NODE) {
            foreach my $child ($node->childNodes) {
                next unless $child->nodeType == XML_ENTITY_DECL;

                $self->{entities}->{$child->nodeName} = ord $child->nodeValue;
            }
        }
        elsif ($node->nodeType == XML_ELEMENT_NODE) {
            $self->_build_node($node);
        }
        elsif ($node->nodeType == XML_TEXT_NODE) {
            $self->_build_text($node);
        }
        elsif ($node->nodeType == XML_ENTITY_REF_NODE) {
            $self->_build_entity($node);
        }
    }
}

sub _build_node {
    my $self = shift;
    my ($node) = @_;

    my $name = $node->localName;
    my $ns   = $node->namespaceURI;

    my ($tag, $page) = $self->{schema}->get_code($ns, $name);

    if ($node->hasAttributes) {
        $tag |= 2**7;
    }

    if ($node->nodeValue || $node->hasChildNodes) {
        $tag |= 2**6;
    }

    if ($self->{page} != $page) {
        $self->{page} = $page;

        $self->_push(WBXML_SWITCH_PAGE);
        $self->_push($page);
    }

    $self->_push($tag);

    if ($node->hasChildNodes) {
        $self->_build_nodes($node->childNodes);
        $self->_push(WBXML_END);
    }
}

sub _build_text {
    my $self = shift;
    my ($node) = @_;

    $self->_push(WBXML_STR_I);
    $self->_push_string($node->textContent);
}

sub _build_entity {
    my $self = shift;
    my ($node) = @_;

    $self->_push(WBXML_ENTITY);

    my $number = $self->{entities}->{$node->nodeName};

    $self->_push_multibyte($number);
}

sub _push {
    my $self = shift;
    my ($byte) = @_;

    push @{$self->{buffer}}, pack 'C', $byte;
}

sub _push_multibyte {
    my $self = shift;
    my ($integer) = @_;

    push @{$self->{buffer}}, to_mb_u_int32($integer);
}

sub _push_string {
    my $self = shift;
    my ($string) = @_;

    push @{$self->{buffer}}, pack('Z*', $string);
}

1;
