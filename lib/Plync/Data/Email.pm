package Plync::Data::Email;

use strict;
use warnings;

use XML::LibXML;
use String::CamelCase qw(camelize);

sub new {
    my $class = shift;

    my $self = {@_};
    bless $self, $class;

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
        to from subject
        date_received
        display_to
        thread_topic
        importance
        read
        )
      )
    {
        $root->addNewChild('Email:', camelize($_))->appendText($self->{$_});
    }

    my $body = $root->addNewChild('AirSyncBase:', 'Body');
    for (qw(type estimated_data_size truncated data)) {
        next unless defined $self->{body}->{$_};

        $body->addNewChild('AirSyncBase:', camelize($_))
          ->appendText($self->{body}->{$_});
    }

    for (
        qw(
        message_class
        internet_CPID
        flag
        content_class
        )
      )
    {
        $root->addNewChild('Email:', camelize($_))->appendText($self->{$_});
    }

    $root->addNewChild('AirSyncBase:', 'NativeBodyType')
      ->appendText($self->{native_body_type});

    $root->addNewChild('Email2:', 'ConversationId')
      ->appendText($self->{conversation_id});
    $root->addNewChild('Email2:', 'ConversationIndex')
      ->appendText($self->{conversation_index});

    $root->addNewChild('Email:', 'Categories')
      ->appendText($self->{categories});

    return $root;
}

1;
