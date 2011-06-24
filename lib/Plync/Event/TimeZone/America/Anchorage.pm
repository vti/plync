package Plync::Event::TimeZone::America::Anchorage;

use strict;
use warnings;

sub timezone_info {
    {   'bias'          => -540,
        'standard_name' => 'AKST',
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
        'daylight_name' => 'AKDT',
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
    '5P3//0FLU1QAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAsAAAABAAIAAAAAAAAAAAAAAEFLRFQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAMAAAACAAIAAAAAAAAAxP///w=='
}

1;
