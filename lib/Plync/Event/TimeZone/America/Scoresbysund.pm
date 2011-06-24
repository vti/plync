package Plync::Event::TimeZone::America::Scoresbysund;

use strict;
use warnings;

sub timezone_info {
    {   'bias'          => -60,
        'standard_name' => 'EGT',
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
        'daylight_name' => 'EGST',
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
    'xP///0VHVAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAoAAAAFAAEAAAAAAAAAAAAAAEVHU1QAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAMAAAAFAAAAAAAAAAAAxP///w=='
}

1;
