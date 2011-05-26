package Plync::Utils;

use strict;
use warnings;

use base 'Exporter';

our @EXPORT_OK = qw(to_xml);

use String::CamelCase qw(camelize);

sub to_xml {
    my ($hashref) = @_;

    my $xml = '';
    foreach my $key (keys %$hashref) {
        my $tag = camelize $key;

        my $value = $hashref->{$key};
        if (!ref $value) {
            $xml .= "<$tag>$value</$tag>";
        }
        elsif (ref $value eq 'HASH') {
            $xml .= "<$tag>" . to_xml($value) . "</$tag>";;
        }
        elsif (ref $value eq 'ARRAY') {
            foreach my $el (@$value) {
               $xml .= to_xml({$key => $el});
            }
        }
    }

    return $xml;
}

1;
