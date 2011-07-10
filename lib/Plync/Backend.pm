package Plync::Backend;

use strict;
use warnings;

use Class::Load ();

sub new {
    my $class   = shift;
    my $type    = shift;
    my $backend = shift;

    my $backend_class =
        $backend =~ s/^\+//
      ? $backend
      : __PACKAGE__ . '::' . $type . '::' . $backend;

    Class::Load::load_class($backend_class);

    return $backend_class->new(@_);
}

1;
