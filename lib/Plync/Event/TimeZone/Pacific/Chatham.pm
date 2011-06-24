package Plync::Event::TimeZone::Pacific::Chatham;

use strict;
use warnings;

sub timezone_info {
    {   'bias'          => 765,
        'standard_name' => 'CHAST',
        'standard_bias' => 0,
        'standard_date' => {
            'hour'         => 3,
            'second'       => 0,
            'month'        => 4,
            'minute'       => 45,
            'day_of_week'  => 0,
            'day'          => 1,
            'year'         => 0,
            'milliseconds' => 0
        },
        'daylight_name' => 'CHADT',
        'daylight_bias' => -60,
        'daylight_date' => {
            'hour'         => 2,
            'second'       => 0,
            'month'        => 9,
            'minute'       => 45,
            'day_of_week'  => 0,
            'day'          => 5,
            'year'         => 0,
            'milliseconds' => 0
        }
    };
}

sub timezone_info_base64 {
    '/QIAAENIQVNUAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAQAAAABAAMALQAAAAAAAAAAAENIQURUAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAkAAAAFAAIALQAAAAAAxP///w=='
}

1;
