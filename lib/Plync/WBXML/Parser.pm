package Plync::WBXML::Parser;

use strict;
use warnings;

use base 'Plync::WBXML::Base';

use Plync::WBXML::Constants;
use Plync::WBXML::Util qw(read_mb_u_int32);

use I18N::Charset qw(mib_to_charset_name);
use HTML::Entities::Numbered ();
use XML::LibXML;

our %PUBLICIDS = ();

sub version  { shift->{version} }
sub publicid { shift->{publicid} }
sub charset  { shift->{charset} }

sub parse {
    my $self = shift;
    my ($wbxml) = @_;

    $self->{xml} = XML::LibXML::Document->new;

    $self->{page} = 0;

    $self->{buffer} = [split '', $wbxml];

    $self->_parse_version;

    $self->_parse_publicid;

    $self->_parse_charset;

    $self->_parse_strtbl;

    $self->_parse_body;

    return $self;
}

sub to_xml { shift->{xml} }

sub to_string {
    my $self = shift;

    $self->{xml}->toString;
}

sub _parse_version {
    my $self = shift;

    $self->{version} = $self->_read;
}

sub _parse_publicid {
    my $self = shift;

    if (!$self->_look) {
        $self->_read;
        my $index = $self->_read_multibyte;
        die 'TODO';
    }
    else {
        $self->{publicid} = $self->_read_multibyte;
    }
}

sub _parse_charset {
    my $self = shift;

    $self->{charset} = mib_to_charset_name($self->_read_multibyte);
}

sub _parse_strtbl {
    my $self = shift;

    my $length = $self->_read_multibyte;

    if ($length) {
        $self->{strtbl} = $self->_read($length);
    }
}

sub _get_from_strtbl {
    my $self = shift;
    my ($index) = @_;

    my $string = substr($self->{strtbl}, $index);
    $string =~ s/\0.*$//;

    return $string;
}

sub _parse_body {
    my $self = shift;

    $self->_parse_pi;

    my $el = $self->_parse_element('root');

    $self->{xml}->setEncoding($self->{charset});

    $self->_parse_pi;
}

sub _parse_element {
    my $self = shift;
    my ($is_root) = @_;

    $self->_parse_switch_page;

    my ($stag, $has_attrs, $has_content) = $self->_parse_stag;

    my ($tag, $ns) = $self->{schema}->get_tag($self->{page}, $stag);

    my $element;
    if ($is_root) {
        if (my $ns = $self->{schema}->get_namespace(0)) {
            $element = $self->{xml}->createElementNS("$ns:", $tag);
        }
        else {
            $element = $self->{xml}->createElement($tag);
        }

        $self->{xml}->setDocumentElement($element);
    }
    else {
        $element = XML::LibXML::Element->new($tag);
    }

    if ($ns) {
        $self->{xml}->documentElement->setNamespace("$ns:", lc $ns, 0);
        $element->setNamespace("$ns:", lc $ns, 1);
    }

    if ($has_attrs) {
        my $attrs = $self->_parse_attrs;
        for (my $i = 0; $i < @$attrs; $i += 2) {
            $element->setAttribute($attrs->[$i] => $attrs->[$i + 1]);
        }
    }

    if ($has_content) {
        my $content = $self->_parse_content;
        foreach my $node (@$content) {
            if (!ref $node) {
                $element->appendText($node);
            }
            else {
                $element->appendChild($node);
            }
        }
    }

    return $element;
}

sub _parse_stag {
    my $self = shift;

    my $look = $self->_look;

    if (   $look == WBXML_LITERAL
        || $look == WBXML_LITERAL_A
        || $look == WBXML_LITERAL_C
        || $look == WBXML_LITERAL_AC)
    {
        $self->_read;
        my $index = $self->_read;
        die 'TODO';
        return 1;
    }

    my $stag = $self->_read;

    my $has_attrs   = !!($stag & 2**7);
    my $has_content = !!($stag & 2**6);
    $stag &= 2**6 - 1;

    return ($stag, $has_attrs, $has_content);
}

sub _parse_pi {
    my $self = shift;

    return unless defined $self->_look && $self->_look == WBXML_PI;

    warn 'PI';
}

sub _parse_attrs {
    my $self = shift;

    my $attrs = [];

    while (1) {
        my ($key, $value) = $self->_parse_attr;

        push @$attrs, $key => $value;

        if ($self->_look == WBXML_END) {
            $self->_read;
            last;
        }
    }

    return $attrs;
}

sub _parse_attr {
    my $self = shift;

    my $code = $self->_parse_attr_start;

    my ($key, $prefix) = $self->{schema}->get_attr_name($self->{page}, $code);

    my $values = [];

    while ($self->_look != WBXML_END
        && defined(my $value = $self->_parse_attr_value))
    {
        push @$values, "$value";
    }

    return ($key, $prefix . join('', @$values));
}

sub _parse_attr_start {
    my $self = shift;

    if ($self->_look == WBXML_LITERAL) {
        $self->_read;
        my $index = $self->_read_multibyte;
        die 'TODO';
    }
    else {
        $self->_parse_switch_page;

        return $self->_read;
    }
}

sub _parse_attr_value {
    my $self = shift;

    my $value;

    if (defined($value = $self->_parse_string)) {
        return $value;
    }

    #elsif (defined($value = $self->_parse_extension)) {
    #    return $value;
    #}
    elsif (defined($value = $self->_parse_entity)) {
        return $value;
    }
    elsif (defined($value = $self->_parse_opaque)) {
        return $value;
    }

    $self->_parse_switch_page;

    return if $self->_look < 128;

    my $code = $self->_read;

    return $self->{schema}->get_attr_value($self->{page}, $code);
}

sub _parse_switch_page {
    my $self = shift;

    return unless $self->_look == WBXML_SWITCH_PAGE;

    $self->_read;

    my $page = $self->_read;
    $self->{page} = $page;

    return $page;
}

sub _parse_content {
    my $self = shift;

    my $content = [];
    while ($self->_look != WBXML_END) {
        my $current;

        if (defined($current = $self->_parse_string)) {
        }

        #elsif (defined($current = $self->_parse_extension)) {
        #}
        elsif (defined($current = $self->_parse_entity)) {
        }
        elsif (defined($current = $self->_parse_pi)) {
        }
        elsif (defined($current = $self->_parse_opaque)) {
        }
        elsif (defined($current = $self->_parse_element)) {
        }

        push @$content, $current;
    }

    $self->_read;

    return $content;
}

sub _parse_string {
    my $self = shift;

    if ($self->_look == WBXML_STR_I) {
        $self->_read;
        my $string = '';
        while (my $byte = $self->_read) {
            $string .= chr $byte;
        }
        return $string;
    }
    elsif ($self->_look == WBXML_STR_T) {
        $self->_read;
        my $index = $self->_read_multibyte;
        return $self->_get_from_strtbl($index);
    }

    return;
}

sub _parse_extension {
    my $self = shift;

    my $look = $self->_look;

    $self->_parse_switch_page;

    if (   $look == WBXML_EXT_I_0
        || $look == WBXML_EXT_I_1
        || $look == WBXML_EXT_I_2)
    {
        die 'TODO';
        $self->_read;
        my $string = '';
        while (my $byte = $self->_read) {
            $string .= chr $byte;
        }
        return 1;
    }
    elsif ($look == WBXML_EXT_T_0
        || $look == WBXML_EXT_T_1
        || $look == WBXML_EXT_T_2)
    {
        die 'TODO';
        $self->_read;
        my $index = $self->_read_multibyte;
        return 1;
    }

    return;
}

sub _parse_entity {
    my $self = shift;

    return unless $self->_look == WBXML_ENTITY;

    $self->_read;

    my $entcode = $self->_read_multibyte;

    return HTML::Entities::Numbered::decimal2name("&#$entcode;");
}

sub _parse_opaque {
    my $self = shift;

    return unless $self->_look == WBXML_OPAQUE;

    $self->_read;

    my $length = $self->_read_multibyte;
    if ($length) {
        my $bytes = $self->_read($length);
    }

    return 1;
}

sub _look {
    my $self = shift;

    return @{$self->{buffer}} ? unpack 'C', $self->{buffer}->[0] : undef;
}

sub _read {
    my $self = shift;
    my ($count) = @_;

    return unpack 'C', shift @{$self->{buffer}} unless $count;

    return join '', splice(@{$self->{buffer}}, 0, $count);
}

sub _unread {
    my $self = shift;
    my ($byte) = @_;

    unshift @{$self->{buffer}}, pack('C', $byte);
}

sub _read_multibyte {
    my $self = shift;

    return read_mb_u_int32($self->{buffer});
}

1;
