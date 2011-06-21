package Plync::Email;

use strict;
use warnings;

use XML::LibXML;
use String::CamelCase qw(camelize);

sub new {
    my $class = shift;

    my $self = {@_};
    bless $self, $class;

    die "Missing 'internet_CPID' param" unless defined $self->{internet_CPID};
    die "Missing 'conversation_id' param"
      unless defined $self->{conversation_id};
    die "Missing 'conversation_index' param"
      unless defined $self->{conversation_index};

    return $self;
}

sub id { shift->{id} }

sub appendTo {
    my $self = shift;
    my ($doc, $root) = @_;

    $doc->documentElement->setNamespace('AirSyncBase:', 'airsyncbase', 0);
    $doc->documentElement->setNamespace('Email:',       'email',       0);
    $doc->documentElement->setNamespace('Email2:',      'email2',      0);

    for (
        qw(
        to cc from subject reply_to
        date_received display_to
        thread_topic importance
        read
        )
      )
    {
        next unless defined $self->{$_};
        $root->addNewChild('Email:', camelize($_))->appendText($self->{$_});
    }

    # TODO attachments

    if (defined $self->{body}) {
        die "Missing 'type' param" unless defined $self->{body}->{type};

        my $body = $root->addNewChild('AirSyncBase:', 'Body');
        for (qw(type estimated_data_size truncated data)) {
            next unless defined $self->{body}->{$_};

            $body->addNewChild('AirSyncBase:', camelize($_))
              ->appendText($self->{body}->{$_});
        }
    }

    # TODO meeting request

    for (
        qw(
        message_class
        internet_CPID
        content_class
        )
      )
    {
        next unless defined $self->{$_};
        $root->addNewChild('Email:', camelize($_))->appendText($self->{$_});
    }

    # TODO flag

    if (defined $self->{native_body_type}) {
        $root->addNewChild('AirSyncBase:', 'NativeBodyType')
          ->appendText($self->{native_body_type});
    }

    # TODO um_called_id um_user_notes

    $root->addNewChild('Email2:', 'ConversationId')
      ->appendText($self->{conversation_id});
    $root->addNewChild('Email2:', 'ConversationIndex')
      ->appendText($self->{conversation_index});

    # TODO last_verb_executed last_verb_execution_time received_as_bcc sender

    # TODO categories

    # TODO body_part account_id rights_management_license

    return $root;
}

1;
