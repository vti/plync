package PlyncCommandFolderSyncTest;

use strict;
use warnings;

use base 'PlyncCommandTestBase';

use Test::Plync;
use Test::Plync::Backend;

sub make_fixture : Test(setup) {
    my $self = shift;

    my $backend = Test::Plync->build_backend;

    my $device = Test::Plync->build_device(backend => $backend);

    $self->{device} = $device;
}

sub test_invalid_sync_key : Test {
    my $self = shift;

    my $in = <<'EOF';
<?xml version="1.0" encoding="UTF-8"?>
<FolderSync xmlns="FolderHierarchy:">
  <SyncKey></SyncKey>
</FolderSync>
EOF

    my $out = <<'EOF';
<?xml version="1.0" encoding="utf-8"?>
<FolderSync xmlns="FolderHierarchy:">
  <Status>10</Status>
</FolderSync>
EOF

    is $self->_run_command('FolderSync', $in), $out;
}

sub test_initial_sync : Test {
    my $self = shift;

    my $in = <<'EOF';
<?xml version="1.0" encoding="UTF-8"?>
<FolderSync xmlns="FolderHierarchy:">
  <SyncKey>0</SyncKey>
</FolderSync>
EOF

    my $out = <<'EOF';
<?xml version="1.0" encoding="utf-8"?>
<FolderSync xmlns="FolderHierarchy:">
  <Status>1</Status>
  <SyncKey>1</SyncKey>
  <Changes>
    <Count>1</Count>
    <Add>
      <ServerId>1</ServerId>
      <ParentId>0</ParentId>
      <DisplayName>Inbox</DisplayName>
      <Type>2</Type>
    </Add>
  </Changes>
</FolderSync>
EOF

    is $self->_run_command('FolderSync', $in), $out;
}

sub test_changes : Test {
    my $self = shift;

    my $in = <<'EOF';
<?xml version="1.0" encoding="UTF-8"?>
<FolderSync xmlns="FolderHierarchy:">
  <SyncKey>0</SyncKey>
</FolderSync>
EOF

    $self->_run_command('FolderSync', $in);

    $in = <<'EOF';
<?xml version="1.0" encoding="UTF-8"?>
<FolderSync xmlns="FolderHierarchy:">
  <SyncKey>1</SyncKey>
</FolderSync>
EOF

    my $out = <<'EOF';
<?xml version="1.0" encoding="utf-8"?>
<FolderSync xmlns="FolderHierarchy:">
  <Status>1</Status>
  <SyncKey>2</SyncKey>
</FolderSync>
EOF

    is $self->_run_command('FolderSync', $in), $out;
}

sub test_wrong_sync_key : Test {
    my $self = shift;

    my $in = <<'EOF';
<?xml version="1.0" encoding="UTF-8"?>
<FolderSync xmlns="FolderHierarchy:">
  <SyncKey>123</SyncKey>
</FolderSync>
EOF

    my $out = <<'EOF';
<?xml version="1.0" encoding="utf-8"?>
<FolderSync xmlns="FolderHierarchy:">
  <Status>9</Status>
  <SyncKey>0</SyncKey>
</FolderSync>
EOF

    is $self->_run_command('FolderSync', $in), $out;
}

1;
