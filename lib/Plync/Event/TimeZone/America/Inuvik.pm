package Plync::Event::TimeZone::America::Inuvik;

use strict;
use warnings;

sub timezone_info {
    {   'bias'          => -420,
        'standard_name' => 'MST',
        'standard_bias' => 0,
        'standard_date' => {
            'hour'         => 2,
            'second'       => 0,
            'month'        => 11,
            'minute'       => 0,
            'day_of_week'  => 0,
            'day'          => 1,
            'year'         => 0,
            'milliseconds' => 0
        },
        'daylight_name' => 'MDT',
        'daylight_bias' => -60,
        'daylight_date' => {
            'hour'         => 2,
            'second'       => 0,
            'month'        => 3,
            'minute'       => 0,
            'day_of_week'  => 0,
            'day'          => 2,
            'year'         => 0,
            'milliseconds' => 0
        }
    };
}

sub timezone_info_base64 {
    'XP7//01TVAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAsAAAABAAIAAAAAAAAAAAAAAE1EVAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAMAAAACAAIAAAAAAAAAxP///w=='
}

1;
