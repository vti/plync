package Plync::Event::TimeZone::Pacific::Fakaofo;

use strict;
use warnings;

sub timezone_info {
    {   'bias'          => -600,
        'standard_name' => 'TKT',
        'standard_bias' => 0,
        'standard_date' => {
            'hour'         => 0,
            'second'       => 0,
            'month'        => 0,
            'minute'       => 0,
            'day_of_week'  => 0,
            'day'          => 0,
            'year'         => 0,
            'milliseconds' => 0
        },
        'daylight_name' => '',
        'daylight_bias' => 0,
        'daylight_date' => {
            'hour'         => 0,
            'second'       => 0,
            'month'        => 0,
            'minute'       => 0,
            'day_of_week'  => 0,
            'day'          => 0,
            'year'         => 0,
            'milliseconds' => 0
        }
    };
}

sub timezone_info_base64 {
    'qP3//1RLVAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=='
}

1;
