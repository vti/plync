package Plync::Event::TimeZone::Europe::Jersey;

use strict;
use warnings;

sub timezone_info {
    {   'bias'          => 0,
        'standard_name' => 'GMT',
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
        'daylight_name' => 'BST',
        'daylight_bias' => -60,
        'daylight_date' => {
            'hour'         => 1,
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
    'AAAAAEdNVAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAoAAAAFAAIAAAAAAAAAAAAAAEJTVAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAMAAAAFAAEAAAAAAAAAxP///w=='
}

1;
