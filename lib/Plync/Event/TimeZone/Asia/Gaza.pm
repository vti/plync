package Plync::Event::TimeZone::Asia::Gaza;

use strict;
use warnings;

sub timezone_info {
    {   'bias'          => 120,
        'standard_name' => 'EET',
        'standard_bias' => 0,
        'standard_date' => {
            'hour'         => 2,
            'second'       => 0,
            'month'        => 9,
            'minute'       => 0,
            'day_of_week'  => 5,
            'day'          => 1,
            'year'         => 0,
            'milliseconds' => 0
        },
        'daylight_name' => 'EEST',
        'daylight_bias' => -60,
        'daylight_date' => {
            'hour'         => 0,
            'second'       => 0,
            'month'        => 3,
            'minute'       => 1,
            'day_of_week'  => 6,
            'day'          => 5,
            'year'         => 0,
            'milliseconds' => 0
        }
    };
}

sub timezone_info_base64 {
    'eAAAAEVFVAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAkABQABAAIAAAAAAAAAAAAAAEVFU1QAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAMABgAFAAAAAQAAAAAAxP///w=='
}

1;
