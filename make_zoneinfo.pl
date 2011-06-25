#!/usr/bin/env perl

# 1. Download OLSON data
#   ftp://elsie.nci.nih.gov/pub/
# 2. Convert to ics
#   vzic --olson-dir tzdata2011g/
# 3. make_zoneinfo.pl zoneinfo lib/Plync/Event/TimeZone

use strict;
use warnings;

use Text::vFile::asData;
use MIME::Base64;
use File::Basename ();
use File::Path     ();

my $namespace = 'Plync::Event::TimeZone::';

my %DAYS_OF_WEEK = (
    'SU' => 0,
    'MO' => 1,
    'TU' => 2,
    'WE' => 3,
    'TH' => 4,
    'FR' => 5,
    'SA' => 6
);

my ($from, $to) = @ARGV;

die "Usage: $0 <from> <to>" unless $from && $to;

die 'not a directory' unless -d $from;

my @files = get_files($from);

foreach my $file (@files) {
    my $class_name = $file;
    $class_name =~ s{^$from/}{};
    $class_name =~ s{/}{::}g;
    $class_name =~ s/\.ics$//;

    my $output = $file;
    $output =~ s{^$from/}{$to/};
    File::Path::make_path(File::Basename::dirname($output));
    $output =~ s{.ics$}{.pm};

    my $tz = parse_ics($file);

    open my $fh, '>', $output or die $!;
    print $fh zoneinfo_to_class($class_name, $tz);
    close $fh;
}

sub get_files {
    my $dir = shift;

    my @files;

    opendir(my $dh, $dir) or die "can't opendir $dir: $!";

    my @el = readdir($dh);

    foreach my $file (@el) {
        next if $file =~ m/^\./;

        my $path = "$dir/$file";

        if (-f $path) {
            push @files, $path;
        }
        elsif (-d $path) {
            push @files, get_files($path);
        }
    }

    closedir $dh;

    return @files;
}

sub parse_ics {
    my $file = shift;

    open my $fh, $file or die "couldn't open ics: $!";
    my $data = Text::vFile::asData->new->parse($fh);
    close $fh;

    my ($std, $dls);

    my $objects = $data->{objects}->[0]->{objects}->[0]->{objects};

    foreach my $object (@$objects) {
        if ($object->{type} eq 'STANDARD') {
            $std = $object->{properties};
        }
        else {
            $dls = $object->{properties};
        }
    }

    my $tz;

    my $std_from = offset_to_minutes($std->{TZOFFSETFROM}->[0]->{value});
    my $std_to   = offset_to_minutes($std->{TZOFFSETTO}->[0]->{value});

    $tz = {
        bias          => $std_to,
        standard_name => $std->{TZNAME}->[0]->{value} || '',
        standard_bias => 0
    };

    if ($std_from ne $std_to) {
        $tz->{standard_date} = parse_date($std);

        my $dls_from = offset_to_minutes($dls->{TZOFFSETFROM}->[0]->{value});
        my $dls_to   = offset_to_minutes($dls->{TZOFFSETTO}->[0]->{value});

        $tz->{daylight_name} = $dls->{TZNAME}->[0]->{value};
        $tz->{daylight_date} = parse_date($dls);
        $tz->{daylight_bias} = -60;
    }
    else {
        $tz->{standard_date} = {
            year         => 0,
            month        => 0,
            day_of_week  => 0,
            day          => 0,
            hour         => 0,
            minute       => 0,
            second       => 0,
            milliseconds => 0,
        };

        $tz->{daylight_name} = '';
        $tz->{daylight_date} = $tz->{standard_date};
        $tz->{daylight_bias} = 0;
    }

    return $tz;
}

sub encode_zoneinfo {
    my ($tz) = @_;

    my $packed = pack 'la64S8la64S8l', $tz->{bias}, $tz->{standard_name},
      $tz->{standard_date}->{year},
      $tz->{standard_date}->{month},
      $tz->{standard_date}->{day_of_week},
      $tz->{standard_date}->{day},
      $tz->{standard_date}->{hour},
      $tz->{standard_date}->{minute},
      $tz->{standard_date}->{second},
      $tz->{standard_date}->{milliseconds},
      $tz->{standard_bias},
      $tz->{daylight_name},
      $tz->{daylight_date}->{year},
      $tz->{daylight_date}->{month},
      $tz->{daylight_date}->{day_of_week},
      $tz->{daylight_date}->{day},
      $tz->{daylight_date}->{hour},
      $tz->{daylight_date}->{minute},
      $tz->{daylight_date}->{second},
      $tz->{daylight_date}->{milliseconds},
      $tz->{daylight_bias};

    my $base64 = encode_base64($packed);
    $base64 =~ s/\s+//g;

    return $base64;
}

sub zoneinfo_to_class {
    my ($name, $tz) = @_;

    my $base64 = encode_zoneinfo($tz);

    return <<"EOF";
package $namespace$name;

use strict;
use warnings;

sub timezone_info {
    {   'bias'          => $tz->{bias},
        'standard_name' => '$tz->{standard_name}',
        'standard_bias' => $tz->{standard_bias},
        'standard_date' => {
            'hour'         => $tz->{standard_date}->{hour},
            'second'       => $tz->{standard_date}->{second},
            'month'        => $tz->{standard_date}->{month},
            'minute'       => $tz->{standard_date}->{minute},
            'day_of_week'  => $tz->{standard_date}->{day_of_week},
            'day'          => $tz->{standard_date}->{day},
            'year'         => $tz->{standard_date}->{year},
            'milliseconds' => $tz->{standard_date}->{milliseconds}
        },
        'daylight_name' => '$tz->{daylight_name}',
        'daylight_bias' => $tz->{daylight_bias},
        'daylight_date' => {
            'hour'         => $tz->{daylight_date}->{hour},
            'second'       => $tz->{daylight_date}->{second},
            'month'        => $tz->{daylight_date}->{month},
            'minute'       => $tz->{daylight_date}->{minute},
            'day_of_week'  => $tz->{daylight_date}->{day_of_week},
            'day'          => $tz->{daylight_date}->{day},
            'year'         => $tz->{daylight_date}->{year},
            'milliseconds' => $tz->{daylight_date}->{milliseconds}
        }
    };
}

sub timezone_info_base64 {
    '$base64'
}

1;
EOF
}

sub parse_date {
    my $object = shift;

    my $date = $object->{RRULE}->[0]->{value};
    my ($freq, $month, $day_number, $day) =
      $date =~ m/FREQ=(.*?);BYMONTH=(.*?);BYDAY=(-?\d+)(.*)/;

    $day_number = 5 if $day_number == -1;

    my $time = $object->{DTSTART}->[0]->{value};
    my ($hour, $minute, $second) = $time =~ m/T(\d{2})(\d{2})(\d{2})$/;

    return {
        year         => 0,
        month        => $month,
        day_of_week  => $DAYS_OF_WEEK{$day},
        day          => $day_number,
        hour         => int($hour),
        minute       => int($minute),
        second       => int($second),
        milliseconds => 0,
    };
}

sub offset_to_minutes {
    my $offset = shift;

    my ($sign, $hour, $minutes) = $offset =~ m/^(\+|\-)(\d\d)(\d\d)$/;
    my $offset_in_minutes = $hour * 60 + $minutes;

    if ($sign eq '-') {
        $offset_in_minutes *= -1;
    }

    return $offset_in_minutes;
}
