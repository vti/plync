package Plync::Backend::Calendar::vCalendar::Parser;

use strict;
use warnings;

use Plync::Event;
use Text::vFile::asData;

sub parse {
    my $self = shift;
    my ($contents) = @_;

    open my $fh, '<', \$contents;
    my $data = Text::vFile::asData->new->parse($fh);

    my $events = [];

    foreach my $calendar (@{$data->{objects}}) {
        my $type  = $calendar->{type};
        my $props = $calendar->{properties};
        my $items = $calendar->{objects};

        next unless $type eq 'VCALENDAR';

        my $timezone = $props->{'X-WR-TIMEZONE'}->[0]->{value};

        foreach my $item (@$items) {
            next unless $item->{type} eq 'VEVENT';

            my $props = $item->{properties};

            my $event = {
                id            => $props->{UID}->[0]->{value},
                time_zone     => $timezone,
                all_day_event => 0,                             # TODO
                body          => {

                    # 1 Plain text
                    # 2 HTML
                    # 3 RTF
                    type                => 3,
                    estimated_data_size => 0,                   # TODO
                    truncated           => 0,                   # TODO

                    #data => '',
                    #preview => ''
                },
                busy_status     => 0,                                 # TODO
                organizer_name  => '',                                # TODO
                organizer_email => '',                                # TODO
                DT_stamp        => $props->{DTSTAMP}->[0]->{value},
                end_time => vcal_datetime($props->{DTEND}->[0]->{value}),
                location => $props->{LOCATION}->[0]->{value},
                reminder    => 0,                                     # TODO
                sensitivity => 0,                                     # TODO
                subject     => $props->{SUMMARY}->[0]->{value}
                  || $props->{DESCRIPTION}->[0]->{value},
                start_time => vcal_datetime($props->{DTSTART}->[0]->{value}),
                UID        => $props->{UID}->[0]->{value},
                meeting_status         => 1,                            # TODO
                attendees              => [],                           # TODO
                categories             => [],                           # TODO
                recurrence             => {},                           # TODO
                exceptions             => {},                           # TODO
                response_requested     => 0,                            # TODO
                appointment_reply_time => undef,                        # TODO
                response_type          => vcal_status_to_response_type(
                    $props->{STATUS}->[0]->{value}
                ),
                disallow_new_time_proposal => 0,                        # TODO

                # 1 Plain text
                # 2 HTML
                # 3 RTF
                native_body_type => 3,                                  # TODO

                online_meeting_conf_link     => undef,    # TODO GRUU
                online_meeting_external_link => undef,    # TODO URL
            };

            push @$events, $self->_build_event($event);
        }
    }

    return $events;
}

sub _build_event {
    my $self = shift;
    my ($event) = @_;

    return Plync::Event->new(%$event);
}

sub vcal_status_to_response_type {
    my $status = shift;

    my $statuses = {
        TENTATIVE => 2,
        CONFIRMED => 3,
        CANCELLED => 4
    };

    return $statuses->{$status};
}

sub vcal_datetime {
    my $datetime = shift;

    if (length $datetime == 8) {
        $datetime .= 'T000000Z';
    }

    return $datetime;
}

1;
