package Plync::Command::Ping::Response;

use strict;
use warnings;

use base 'Plync::Command::BaseResponse';

use Plync::Utils qw(to_xml);

sub to_string {
    my $self = shift;

    $self->{status} ||= 1;

    if ($self->{status} == 1) {
        return <<'EOF';
<?xml version="1.0" encoding="utf-8"?>
<Ping xmlns="Ping:">
<Status>1</Status>
</Ping>
EOF
    }
    elsif ($self->{status} == 2) {
        my $folders = to_xml({folder => $self->{folders}});
        return <<"EOF";
<?xml version="1.0" encoding="utf-8"?>
<Ping xmlns="Ping:">
<Status>2</Status>
<Folders>
$folders
</Folders>
</Ping>
EOF
    }
    elsif ($self->{status} == 5) {
        return <<"EOF";
<?xml version="1.0" encoding="utf-8"?>
<Ping xmlns="Ping:">
<Status>5</Status>
<HeartbeatInterval>$self->{interval}</HeartbeatInterval>
</Ping>
EOF
    }
    elsif ($self->{status} == 6) {
        return <<"EOF";
<?xml version="1.0" encoding="utf-8"?>
<Ping xmlns="Ping:">
<Status>6</Status>
<MaxFolders>$self->{max_folders}</MaxFolders>
</Ping>
EOF
    }

    return;
}

1;
