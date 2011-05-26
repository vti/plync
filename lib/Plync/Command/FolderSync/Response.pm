package Plync::Command::FolderSync::Response;

use strict;
use warnings;

use base 'Plync::Command::BaseResponse';

use Plync::Utils qw(to_xml);

sub to_string {
    my $self = shift;

    my $status   = $self->{status};
    my $sync_key = $self->{sync_key};
    my $count    = @{$self->{changes}};

#    my @changes;
#    foreach my $change (@{$self->{changes}}) {
#        push @changes, <<"EOF";
#<Add>
#<ServerId>$change->{server_id}</ServerId>
#<ParentId>$change->{parent_id}</ParentId>
#<DisplayName>$change->{display_name}</DisplayName>
#<Type>$change->{type}</Type>
#</Add>
#EOF
#    }
    my $changes = to_xml({add => $self->{changes}});

    return <<"EOF";
<?xml version="1.0" encoding="utf-8"?>
<FolderSync xmlns="FolderHierarchy:">
<Status>$status</Status>
<SyncKey>$sync_key</SyncKey>
<Changes>
<Count>$count</Count>
$changes
</Changes>
</FolderSync>
EOF

    return;
}

1;
