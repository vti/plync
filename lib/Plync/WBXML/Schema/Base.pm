package Plync::WBXML::Schema::Base;

use strict;
use warnings;

sub schema {
    my $class = shift;

    no strict;

    ${"$class\::_instance"} ||= $class->_new_instance(@_);

    return ${"$class\::_instance"};
}

sub get_namespace {
    my $self = shift;
    my ($page) = @_;

    return $self->_get('PAGES')->{$page};
}

sub get_code {
    my $self = shift;
    my ($namespace, $tag) = @_;

    my $page = 0;

    if (defined $namespace) {
        die "Unknown namespace '$namespace'"
          unless defined($page = $self->_get('NAMESPACES')->{$namespace});
    }
    else {
        $namespace = '';
    }

    return ($self->_get('TAGS')->{$namespace}->{$tag}, $page);
}

sub get_tag {
    my $self = shift;
    my ($page, $code) = @_;

    my $tag = $self->_get('CODES')->{$page}->{$code};

    if (defined $tag) {
        my $ns = $self->_get('PAGES')->{$page};
        $ns = '' unless defined $ns;

        return ($tag, $ns);
    }

    $tag =
      'TAG-0x' . sprintf('%02x', $code) . ' (' . $page . ')';

    die "Unknown tag $tag";
    return ($tag, '');
}

sub get_attr_name {
    my $self = shift;
    my ($page, $code) = @_;

    my $name = $self->_get('ATTR_NAMES')->{$page}->{$code};

    if (defined $name) {
        my $prefix = '';
        ($name, $prefix) = split '=', $name if $name =~ m/=/;
        return ($name, $prefix);
    }

    $name = sprintf '%02x', $name;
    $name = "ATTR-0x$name";

    die 'Unknown attr';
    return ($name, '');
}

sub get_attr_value {
    my $self = shift;
    my ($page, $code) = @_;

    my $value = $self->_get('ATTR_VALUES')->{$page}->{$code};

    $value = 'ATTR-VALUE-' . sprintf('%02x', $code) unless defined $value;

    return $value;
}

sub _get {
    my $self = shift;
    my $class = ref $self;
    my ($name) = @_;

    no strict;
    return ${"$class\::$name"} || {};
}

sub _new_instance {
    my $class = shift;

    return bless {@_}, $class;
}

1;
