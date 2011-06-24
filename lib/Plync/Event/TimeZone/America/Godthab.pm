package Plync::Event::TimeZone::America::Godthab;

use strict;
use warnings;

sub timezone_info {
    {   'bias'          => -180,
        'standard_name' => 'WGT',
        'standard_bias' => 0,
        'standard_date' => {
            'hour'         => 23,
            'second'       => 0,
            'month'        => 10,
            'minute'       => 0,
            'day_of_week'  => 6,
            'day'          => 5,
            'year'         => 0,
            'milliseconds' => 0
        },
        'daylight_name' => 'WGST',
        'daylight_bias' => -60,
        'daylight_date' => {
            'hour'         => 22,
            'second'       => 0,
            'month'        => 3,
            'minute'       => 0,
            'day_of_week'  => 6,
            'day'          => 5,
            'year'         => 0,
            'milliseconds' => 0
        }
    };
}

sub timezone_info_base64 {
    'TP///1dHVAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAoABgAFABcAAAAAAAAAAAAAAFdHU1QAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAMABgAFABYAAAAAAAAAxP///w=='
}

1;
