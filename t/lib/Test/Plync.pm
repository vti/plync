package Test::Plync;

use strict;
use warnings;

use base 'Test::More';

use Test::More;
use Test::MockObject::Extends;

our @EXPORT = @Test::More::EXPORT;
my $CLASS = __PACKAGE__;

use Test::Plync::Backend;
use Plync::Device;
use Plync::FolderSetSyncable;
use Plync::Folder;

sub build_backend {
    my $self = shift;

    return Test::Plync::Backend->new(@_);
}

sub build_device {
    my $self = shift;

    my $device = Plync::Device->new(@_);
    $device = Test::MockObject::Extends->new($device);
    $device->mock(
        _build_folder_set => sub {
            my $folder_set =
              Plync::FolderSetSyncable->new($_[1],
                sync_key_generator => sub { ++$_[0]->{sync_key} });

            $folder_set = Test::MockObject::Extends->new($folder_set);
            $folder_set->mock(
                _build_folder => sub {
                    Plync::FolderSyncable->new($_[1],
                        sync_key_generator => sub { ++$_[0]->{sync_key} });
                }
            );

            return $folder_set;
        }
    );

    return $device;
}

1;
