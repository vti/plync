package Plync::Command::Sync::Response;

use strict;
use warnings;

use base 'Plync::Command::BaseResponse';

use Plync::Utils qw(to_xml);

sub to_string {
    my $self = shift;

    my $collections = to_xml({collection => $self->{collections}});

    return <<"EOF";
<?xml version="1.0" encoding="utf-8"?>
<Sync xmlns="AirSync:">
<Collections>
$collections
</Collections>
</Sync>
EOF
}

1;
