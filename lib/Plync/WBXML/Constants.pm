package Plync::WBXML::Constants;

use strict;
use warnings;

use constant WBXML_SWITCH_PAGE => 0x00;
use constant WBXML_END         => 0x01;
use constant WBXML_ENTITY      => 0x02;
use constant WBXML_STR_I       => 0x03;
use constant WBXML_LITERAL     => 0x04;
use constant WBXML_EXT_I_0     => 0x40;
use constant WBXML_EXT_I_1     => 0x41;
use constant WBXML_EXT_I_2     => 0x42;
use constant WBXML_PI          => 0x43;
use constant WBXML_LITERAL_C   => 0x44;
use constant WBXML_EXT_T_0     => 0x80;
use constant WBXML_EXT_T_1     => 0x81;
use constant WBXML_EXT_T_2     => 0x82;
use constant WBXML_STR_T       => 0x83;
use constant WBXML_LITERAL_A   => 0x84;
use constant WBXML_EXT_0       => 0xC0;
use constant WBXML_EXT_1       => 0xC1;
use constant WBXML_EXT_2       => 0xC2;
use constant WBXML_OPAQUE      => 0xC3;
use constant WBXML_LITERAL_AC  => 0xC4;

use base 'Exporter';

our @EXPORT = qw(
  WBXML_SWITCH_PAGE
  WBXML_END
  WBXML_ENTITY
  WBXML_STR_I
  WBXML_LITERAL
  WBXML_EXT_I_0
  WBXML_EXT_I_1
  WBXML_EXT_I_2
  WBXML_PI
  WBXML_LITERAL_C
  WBXML_EXT_T_0
  WBXML_EXT_T_1
  WBXML_EXT_T_2
  WBXML_STR_T
  WBXML_LITERAL_A
  WBXML_EXT_0
  WBXML_EXT_1
  WBXML_EXT_2
  WBXML_OPAQUE
  WBXML_LITERAL_AC
);

1;
