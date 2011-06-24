package Plync::Event::TimeZone::Australia::Broken_Hill;

use strict;
use warnings;

sub timezone_info {
    {   'bias'          => 570,
        'standard_name' => 'CST',
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
        'daylight_name' => 'CST',
        'daylight_bias' => -60,
        'daylight_date' => {
            'hour'         => 2,
            'second'       => 0,
            'month'        => 10,
            'minute'       => 0,
            'day_of_week'  => 0,
            'day'          => 1,
            'year'         => 0,
            'milliseconds' => 0
        }
    };
}

sub timezone_info_base64 {
    'OgIAAENTVAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAQAAAABAAMAAAAAAAAAAAAAAENTVAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAoAAAABAAIAAAAAAAAAxP///w=='
}

1;
