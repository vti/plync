package Plync::Event::TimeZone::Europe::Helsinki;

use strict;
use warnings;

sub timezone_info {
    {   'bias'          => 120,
        'standard_name' => 'EET',
        'standard_bias' => 0,
        'standard_date' => {
            'hour'         => 4,
            'second'       => 0,
            'month'        => 10,
            'minute'       => 0,
            'day_of_week'  => 0,
            'day'          => 5,
            'year'         => 0,
            'milliseconds' => 0
        },
        'daylight_name' => 'EEST',
        'daylight_bias' => -60,
        'daylight_date' => {
            'hour'         => 3,
            'second'       => 0,
            'month'        => 3,
            'minute'       => 0,
            'day_of_week'  => 0,
            'day'          => 5,
            'year'         => 0,
            'milliseconds' => 0
        }
    };
}

sub timezone_info_base64 {
    'eAAAAEVFVAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAoAAAAFAAQAAAAAAAAAAAAAAEVFU1QAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAMAAAAFAAMAAAAAAAAAxP///w=='
}

1;
