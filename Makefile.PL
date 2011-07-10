#!/usr/bin/env perl

use 5.008007;

use strict;
use warnings;

use ExtUtils::MakeMaker;

my ($mm) = $ExtUtils::MakeMaker::VERSION =~ /^([^_]+)/;

WriteMakefile(
    NAME         => 'Plync',
    VERSION_FROM => 'lib/Plync.pm',
    ABSTRACT     => 'Mobile data air sync server',
    AUTHOR       => 'Viacheslav Tykhanovskyi <vti@cpan.org>',

    ($mm < 6.3002 ? () : ('LICENSE' => 'artistic_2')),

    (   $mm < 6.46
        ? ()
        : ( META_MERGE => {
                requires  => {perl => '5.008007'},
                resources => {
                    license    => 'http://dev.perl.org/licenses/',
                    repository => 'http://github.com/vti/plync'
                },
                no_index => {directory => [qw/t/]}
            },
            META_ADD => {
                build_requires     => {},
                configure_requires => {}
            },
        )
    ),

    PREREQ_PM => {
        'AnyEvent'                  => '0',
        'Async::MergePoint'         => '0',
        'Carp'                      => '0',
        'Class::Load'               => '0',
        'Plack'                     => '0',
        'Scalar::Util'              => '0',
        'Test::Class'               => '0',
        'Test::MockObject::Extends' => '0',
        'Test::More'                => '0',
        'Try::Tiny'                 => '0',
        'XML::LibXML'               => '0',
        'I18N::Charset'             => '0',
        'HTML::Entities::Numbered'  => '0',
        'YAML::Tiny'                => '0',
        'Async::MergePoint'         => '0',
        'AnyEvent::AIO'             => '0',
        'Linux::Inotify2'           => '0',
        'String::CamelCase'         => '0',
        'Text::vFile::asData        => '0',
    },
    test => {TESTS => 't/*.t t/*/*.t t/*/*/*.t t/*/*/*/*.t'}
);
