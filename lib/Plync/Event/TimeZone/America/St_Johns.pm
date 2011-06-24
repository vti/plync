package Plync::Event::TimeZone::America::St_Johns;

use strict;
use warnings;

sub timezone_info {
    {   'bias'          => -210,
        'standard_name' => 'NST',
        'standard_bias' => 0,
        'standard_date' => {
            'hour'         => 0,
            'second'       => 0,
            'month'        => 11,
            'minute'       => 1,
            'day_of_week'  => 0,
            'day'          => 1,
            'year'         => 0,
            'milliseconds' => 0
        },
        'daylight_name' => 'NDT',
        'daylight_bias' => -60,
        'daylight_date' => {
            'hour'         => 0,
            'second'       => 0,
            'month'        => 3,
            'minute'       => 1,
            'day_of_week'  => 0,
            'day'          => 2,
            'year'         => 0,
            'milliseconds' => 0
        }
    };
}

sub timezone_info_base64 {
    'Lv///05TVAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAsAAAABAAAAAQAAAAAAAAAAAE5EVAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAMAAAACAAAAAQAAAAAAxP///w=='
}

1;
