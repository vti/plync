package Plync::Event::TimeZone::Antarctica::South_Pole;

use strict;
use warnings;

sub timezone_info {
    {   'bias'          => 720,
        'standard_name' => 'NZST',
        'standard_bias' => 0,
        'standard_date' => {
            'hour'         => 3,
            'second'       => 0,
            'month'        => 4,
            'minute'       => 0,
            'day_of_week'  => 0,
            'day'          => 1,
            'year'         => 0,
            'milliseconds' => 0
        },
        'daylight_name' => 'NZDT',
        'daylight_bias' => -60,
        'daylight_date' => {
            'hour'         => 2,
            'second'       => 0,
            'month'        => 9,
            'minute'       => 0,
            'day_of_week'  => 0,
            'day'          => 5,
            'year'         => 0,
            'milliseconds' => 0
        }
    };
}

sub timezone_info_base64 {
    '0AIAAE5aU1QAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAQAAAABAAMAAAAAAAAAAAAAAE5aRFQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAkAAAAFAAIAAAAAAAAAxP///w=='
}

1;
