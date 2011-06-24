package Plync::Event::TimeZone::America::Santa_Isabel;

use strict;
use warnings;

sub timezone_info {
    {   'bias'          => -480,
        'standard_name' => 'PST',
        'standard_bias' => 0,
        'standard_date' => {
            'hour'         => 2,
            'second'       => 0,
            'month'        => 10,
            'minute'       => 0,
            'day_of_week'  => 0,
            'day'          => 5,
            'year'         => 0,
            'milliseconds' => 0
        },
        'daylight_name' => 'PDT',
        'daylight_bias' => -60,
        'daylight_date' => {
            'hour'         => 2,
            'second'       => 0,
            'month'        => 4,
            'minute'       => 0,
            'day_of_week'  => 0,
            'day'          => 1,
            'year'         => 0,
            'milliseconds' => 0
        }
    };
}

sub timezone_info_base64 {
    'IP7//1BTVAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAoAAAAFAAIAAAAAAAAAAAAAAFBEVAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAQAAAABAAIAAAAAAAAAxP///w=='
}

1;
