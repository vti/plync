package Plync::Event::TimeZone::Pacific::Palau;

use strict;
use warnings;

sub timezone_info {
    {   'bias'          => 540,
        'standard_name' => 'PWT',
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
    'HAIAAFBXVAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=='
}

1;
