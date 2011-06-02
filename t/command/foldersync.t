use strict;
use warnings;

use Test::More tests => 5;

use_ok('Plync::Command::FolderSync');

use Plync::Folder;
use Plync::Folders;

my $folders = Plync::Folders->new(sync_key_generator => sub {'1'});
$folders->add(
    Plync::Folder->new(
        id           => 1,
        parent_id    => 0,
        type         => 2,
        class        => 'Email',
        display_name => 'Inbox'
      )
);
$folders->save;

my $command = Plync::Command::FolderSync->new;
$command->dispatch(<<'EOF');
<?xml version="1.0" encoding="UTF-8"?>
<FolderSync xmlns="FolderHierarchy:"><SyncKey></SyncKey></FolderSync>
EOF
is($command->res->status, 10);

my $xml = <<'EOF';
<?xml version="1.0" encoding="UTF-8"?>
<FolderSync xmlns="FolderHierarchy:"><SyncKey>0</SyncKey></FolderSync>
EOF

$command = Plync::Command::FolderSync->new;
is($command->dispatch($xml)->toString, <<'EOF');
<?xml version="1.0" encoding="utf-8"?>
<FolderSync xmlns="FolderHierarchy:"><Status>1</Status><SyncKey>1</SyncKey><Changes><Count>1</Count><Add><ServerId>1</ServerId><ParentId>0</ParentId><DisplayName>Inbox</DisplayName><Type>2</Type></Add></Changes></FolderSync>
EOF

$xml = <<'EOF';
<?xml version="1.0" encoding="UTF-8"?>
<FolderSync xmlns="FolderHierarchy:"><SyncKey>1</SyncKey></FolderSync>
EOF

$command = Plync::Command::FolderSync->new;
is($command->dispatch($xml)->toString, <<'EOF');
<?xml version="1.0" encoding="utf-8"?>
<FolderSync xmlns="FolderHierarchy:"><Status>1</Status><SyncKey>1</SyncKey></FolderSync>
EOF

$xml = <<'EOF';
<?xml version="1.0" encoding="UTF-8"?>
<FolderSync xmlns="FolderHierarchy:"><SyncKey>123</SyncKey></FolderSync>
EOF

$command = Plync::Command::FolderSync->new;
is($command->dispatch($xml)->toString, <<'EOF');
<?xml version="1.0" encoding="utf-8"?>
<FolderSync xmlns="FolderHierarchy:"><Status>9</Status><SyncKey>0</SyncKey></FolderSync>
EOF
