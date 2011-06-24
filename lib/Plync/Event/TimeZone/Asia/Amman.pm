package Plync::Event::TimeZone::Asia::Amman;

use strict;
use warnings;

sub timezone_info {
    {   'bias'          => 120,
        'standard_name' => 'EET',
        'standard_bias' => 0,
        'standard_date' => {
            'hour'         => 1,
            'second'       => 0,
            'month'        => 10,
            'minute'       => 0,
            'day_of_week'  => 5,
            'day'          => 5,
            'year'         => 0,
            'milliseconds' => 0
        },
        'daylight_name' => 'EEST',
        'daylight_bias' => -60,
        'daylight_date' => {
            'hour'         => 23,
            'second'       => 59,
            'month'        => 3,
            'minute'       => 59,
            'day_of_week'  => 4,
            'day'          => 5,
            'year'         => 0,
            'milliseconds' => 0
        }
    };
}

sub timezone_info_base64 {
    'eAAAAEVFVAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAoABQAFAAEAAAAAAAAAAAAAAEVFU1QAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAMABAAFABcAOwA7AAAAxP///w=='
}

1;
