package Plync;

use strict;
use warnings;

use Plync::HTTPException;
use Plync::Dispatcher::WBXML;
use Plack::Request;

our $VERSION = '0.001000';

sub new {
    my $class = shift;

    my $self = {@_};
    bless $self, $class;

    return $self;
}

sub dispatch {
    my $class = shift;
    my ($env) = @_;

    my $req = Plack::Request->new($env);

    return $class->_dispatch_OPTIONS if $req->method eq 'OPTIONS';

    Plync::HTTPException->throw(400) unless $req->method eq 'POST';

    my ($user, $device_id, $device_type) = $class->_get_client_info($req);

    my $protocol_version = '1.0';
    if (my $header = $req->headers->header('Ms-Asprotocolversion')) {
        $protocol_version = $header;
    }

    my $policy_key = '0';
    if (my $header = $req->headers->header('X-Ms-Policy')) {
        $policy_key = $header;
    }

    my $user_agent = 'Unknown';
    if (my $header = $req->headers->header('User-Agent')) {
        $user_agent = $header;
    }

    my $body = Plync::Dispatcher::WBXML->dispatch($req->content);

    my $res = $req->new_response(200);
    $res->content_type('application/vnd.ms-sync.wbxml');
    $res->body($body);

    return $res->finalize;
}

sub _dispatch_OPTIONS {
    my $class = shift;

    my @commands = (
        qw/
          Sync SendMail SmartForward SmartReply GetAttachment GetHierarchy
          CreateCollection DeleteCollection MoveCollection FolderSync FolderCreate
          FolderDelete FolderUpdate MoveItems GetItemEstimate MeetingResponse
          ResolveRecipients ValidateCert Provision Search Ping
          /
    );

    return [
        200,
        [   'MS-Server-ActiveSync'  => '6.5.7638.1',
            'MS-ASProtocolVersions' => '1.0,2.0,2.1,2.5',
            'MS-ASProtocolCommands' => join(',', @commands)
        ],
        ['']
    ];
}

sub _get_client_info {
    my $self = shift;
    my ($req) = @_;

    my $query = $req->query_parameters;

    my $user        = $query->{User};
    my $device_id   = $query->{DeviceId};
    my $device_type = $query->{DeviceType};

    Plync::HTTPException->throw(400)
      unless defined $user && defined $device_id && defined $device_type;

    return ($user, $device_id, $device_type);
}

1;
