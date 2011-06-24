package Plync::Event::TimeZone::Atlantic::Azores;

use strict;
use warnings;

sub timezone_info {
    {   'bias'          => -60,
        'standard_name' => 'AZOT',
        'standard_bias' => 0,
        'standard_date' => {
            'hour'         => 1,
            'second'       => 0,
            'month'        => 10,
            'minute'       => 0,
            'day_of_week'  => 0,
            'day'          => 5,
            'year'         => 0,
            'milliseconds' => 0
        },
        'daylight_name' => 'AZOST',
        'daylight_bias' => -60,
        'daylight_date' => {
            'hour'         => 0,
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
    'xP///0FaT1QAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAoAAAAFAAEAAAAAAAAAAAAAAEFaT1NUAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAMAAAAFAAAAAAAAAAAAxP///w=='
}

1;
