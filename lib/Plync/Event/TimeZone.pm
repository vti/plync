package Plync::Event::TimeZone;

use strict;
use warnings;

use Class::Load ();

sub encode_timezone {
    my $class = shift;
    my ($timezone) = @_;

    my $zone_class = $timezone;
    $zone_class =~ s{/}{::}g;
    $zone_class = __PACKAGE__ . '::' . $zone_class;

    Class::Load::load_class($zone_class);

    return $zone_class->timezone_info_base64;
}

1;
