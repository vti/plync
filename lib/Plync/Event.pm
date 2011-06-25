package Plync::Event;

use strict;
use warnings;

use Plync::Event::TimeZone;
use String::CamelCase qw(camelize);

sub new {
    my $class = shift;

    my $self = {@_};
    bless $self, $class;

    for my $param (qw(subject start_time end_time )) {
        die "Missing '$param' param" unless defined $self->{$param};
    }

    return $self;
}

sub id { shift->{id} }

sub appendTo {
    my $self = shift;
    my ($doc, $root) = @_;

    $doc->documentElement->setNamespace('AirSyncBase:', 'airsyncbase', 0);
    $doc->documentElement->setNamespace('Calendar:',    'calendar',    0);

    if (defined $self->{timezone}) {
        $root->addNewChild('Calendar:', 'Timezone')->appendText($self->_timezone_to_blob($self->{timezone}));
    }

    $self->_append($root, $_) for qw(all_day_event);

    if (defined $self->{body}) {
        my $body = $root->addNewChild('AirSyncBase:', 'Body');
        for (qw(type estimated_data_size truncated data)) {
            next unless defined $self->{body}->{$_};

            $body->addNewChild('AirSyncBase:', camelize($_))
              ->appendText($self->{body}->{$_});
        }
    }

    $self->_append($root, $_)
      for qw( busy_status organizer_name organizer_email
      dt_stamp end_time location reminder sensitivity
      subject start_time UID meeting_status );

    # TODO attendies
    # TODO categories
    # TODO recurrence
    # TODO exceptions

    $self->_append($root, $_)
      for qw( response_requested appointment_reply_time
      response_type dissallow_new_time_proposal );

    if (defined $self->{native_body_type}) {
        $root->addNewChild('AirSyncBase:', 'NativeBodyType')
          ->appendText($self->{native_body_type});
    }

    $self->_append($root, $_) for qw( online_meeting_conf_link
      online_meeting_external_link );
}

sub _append {
    my $self = shift;
    my ($root, $name, $ns) = @_;

    return unless defined $self->{$name};

    $ns ||= 'Calendar:';

    $root->addNewChild($ns, camelize($name))->appendText($self->{$name});
}

sub _timezone_to_blob {
    my $self = shift;
    my ($tz) = @_;

    return Plync::Event::TimeZone->encode_timezone($tz);
}

1;
