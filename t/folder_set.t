use strict;
use warnings;

use Test::More tests => 8;

use_ok('Plync::FolderSet');

use Plync::Folder;

my $set = Plync::FolderSet->new;

is_deeply($set->list, []);

$set->add(
    Plync::Folder->new(
        id           => 1,
        class        => 'Email',
        type         => 'Inbox',
        display_name => 'Inbox'
    )
);

$set->add(
    Plync::Folder->new(
        id           => 2,
        class        => 'Calendar',
        display_name => 'Calendar'
    )
);

is(scalar @{$set->list}, 2);

$set->delete(1);

is(scalar @{$set->list}, 1);

is($set->list->[0]->display_name, 'Calendar');

$set->update(2, 
    Plync::Folder->new(
        id           => 2,
        class        => 'Calendar',
        display_name => 'Calendar2'
    ));

is(scalar @{$set->list}, 1);

is($set->list->[0]->display_name, 'Calendar2');

my $new_set = Plync::FolderSet->new;
$new_set->add(
    Plync::Folder->new(
        id           => 1,
        class        => 'Email',
        type         => 'Inbox',
        display_name => 'Inbox'
    )
);

$set->add_set($new_set);

is(scalar @{$set->list}, 2);
