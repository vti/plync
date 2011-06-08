use strict;
use warnings;

use Test::More tests => 12;

use Plack::Builder;
use XML::LibXML;

my $req_wbxml = pack 'H*',
  '03016a00000d45480338300001494a4b033500014c03456d61696c0001010101';
my $req_xml = <<'EOF';
<?xml version="1.0" encoding="UTF-8"?>
<Ping xmlns="Ping:"><HeartbeatInterval>80</HeartbeatInterval><Folders><Folder><Id>5</Id><Class>Email</Class></Folder></Folders></Ping>
EOF

my $res_wbxml = pack 'H*', '03016a00000d45030a48656c6c6f210a0001';
my $res_xml = <<'EOF';
<?xml version="1.0" encoding="utf-8"?>
<Ping xmlns="Ping:">
Hello!
</Ping>
EOF

my $handler = builder {
    enable "+Plync::Middleware::WBXML";
    sub {
        my $env = shift;

        my $cl = $env->{'CONTENT_LENGTH'};

        my $fh = $env->{'psgi.input'};

        $fh->read(my $buf, $cl);
        is($buf, $req_xml);
        is($buf, $fh->dom->toString);

        [200, ['Content-Type' => 'text/xml'], [$res_xml]];
      }
};

open my $fh, '<', \$req_wbxml;
my $res = $handler->(
    {   'REQUEST_METHOD' => 'POST',
        'CONTENT_LENGTH' => length($req_wbxml),
        'psgi.input'     => $fh
    }
);
my %headers = @{$res->[1]};
is_deeply(
    \%headers,
    {   'Content-Length' => length($res_wbxml),
        'Content-Type'   => 'application/vnd.ms-sync.wbxml'
    }
);
is_deeply($res->[2], [$res_wbxml]);


$handler = builder {
    enable "+Plync::Middleware::WBXML";
    sub {
        my $env = shift;

        my $dom = XML::LibXML->new->parse_string($res_xml);

        [200, ['Content-Type' => 'text/xml'], $dom];
      }
};

open $fh, '<', \$req_wbxml;
$res = $handler->(
    {   'REQUEST_METHOD' => 'POST',
        'CONTENT_LENGTH' => length($req_wbxml),
        'psgi.input'     => $fh
    }
);
%headers = @{$res->[1]};
is_deeply(
    \%headers,
    {   'Content-Length' => length($res_wbxml),
        'Content-Type'   => 'application/vnd.ms-sync.wbxml'
    }
);
is_deeply($res->[2], [$res_wbxml]);


$handler = builder {
    enable "+Plync::Middleware::WBXML";
    sub {
        my $env = shift;

        return sub {
            my $respond = shift;

            my $cl = $env->{'CONTENT_LENGTH'};

            my $fh = $env->{'psgi.input'};

            $fh->read(my $buf, $cl);
            is($buf, $req_xml);
            is($buf, $fh->dom->toString);

            $respond->([200, ['Content-Type' => 'text/xml'], [$res_xml]]);
        }
      }
};

open $fh, '<', \$req_wbxml;
$res = $handler->(
    {   'REQUEST_METHOD' => 'POST',
        'CONTENT_LENGTH' => length($req_wbxml),
        'psgi.input'     => $fh
    }
);
$res->(
    sub {
        my $res = shift;
        my %headers = @{$res->[1]};
        is_deeply(
            \%headers,
            {   'Content-Length' => length($res_wbxml),
                'Content-Type'   => 'application/vnd.ms-sync.wbxml'
            }
        );
        is_deeply($res->[2], [$res_wbxml]);
    }
);

$handler = builder {
    enable "+Plync::Middleware::WBXML";
    sub { }
};

open $fh, '<', \'';
eval {
    $res = $handler->(
        {   'REQUEST_METHOD' => 'POST',
            'CONTENT_LENGTH' => 0,
            'psgi.input'     => $fh
        }
    );
};
isa_ok($@, 'Plync::HTTPException');

open $fh, '<', \'123';
eval {
    $res = $handler->(
        {   'REQUEST_METHOD' => 'POST',
            'CONTENT_LENGTH' => 3,
            'psgi.input'     => $fh
        }
    );
};
isa_ok($@, 'Plync::HTTPException');
