package Plync::Event::TimeZone::Asia::Baku;

use strict;
use warnings;

sub timezone_info {
    {   'bias'          => 240,
        'standard_name' => 'AZT',
        'standard_bias' => 0,
        'standard_date' => {
            'hour'         => 5,
            'second'       => 0,
            'month'        => 10,
            'minute'       => 0,
            'day_of_week'  => 0,
            'day'          => 5,
            'year'         => 0,
            'milliseconds' => 0
        },
        'daylight_name' => 'AZST',
        'daylight_bias' => -60,
        'daylight_date' => {
            'hour'         => 4,
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
    '8AAAAEFaVAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAoAAAAFAAUAAAAAAAAAAAAAAEFaU1QAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAMAAAAFAAQAAAAAAAAAxP///w=='
}

1;
