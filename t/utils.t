use strict;
use warnings;

use Test::More tests => 4;

use Plync::Utils qw(to_xml);

is to_xml({}) => '';

is to_xml({foo => 'bar'}) => '<Foo>bar</Foo>';

is to_xml({hello_there => 'bar'}) => '<HelloThere>bar</HelloThere>';

is to_xml({foo => {'bar' => 'baz'}}) => '<Foo><Bar>baz</Bar></Foo>';

is to_xml({foo => {'bar' => [1, 2, 3]}}) =>
  '<Foo><Bar>1</Bar><Bar>2</Bar><Bar>3</Bar></Foo>';
