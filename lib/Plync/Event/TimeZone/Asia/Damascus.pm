package Plync::Event::TimeZone::Asia::Damascus;

use strict;
use warnings;

sub timezone_info {
    {   'bias'          => 120,
        'standard_name' => 'EET',
        'standard_bias' => 0,
        'standard_date' => {
            'hour'         => 0,
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
            'hour'         => 0,
            'second'       => 0,
            'month'        => 4,
            'minute'       => 0,
            'day_of_week'  => 5,
            'day'          => 1,
            'year'         => 0,
            'milliseconds' => 0
        }
    };
}

sub timezone_info_base64 {
    'eAAAAEVFVAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAoABQAFAAAAAAAAAAAAAAAAAEVFU1QAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAQABQABAAAAAAAAAAAAxP///w=='
}

1;
