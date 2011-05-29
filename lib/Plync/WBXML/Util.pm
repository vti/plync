package Plync::WBXML::Util;

use strict;
use warnings;

use base 'Exporter';

our @EXPORT_OK = qw(to_mb_u_int32 read_mb_u_int32);

sub to_mb_u_int32 {
    my $integer = shift;

    use integer;

    my @octets;

    while (my $part = $integer / (2 ** 7)) {
        $integer -= 2 ** 7;
        push @octets, $part + 128;
    }

    push @octets, $integer;

    return pack 'C*', @octets;
}

sub read_mb_u_int32 {
    my $arrayref = shift;

    my $integer = 0;

    while (@$arrayref) {
        my $value = unpack 'C', shift @$arrayref;

        if ($value >> 7) {
            $integer += $value & 127 * 128;
        }
        else {
            $integer += $value;
            last;
        }
    }

    return $integer;
}

1;
