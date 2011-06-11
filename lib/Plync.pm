package Plync;

use strict;
use warnings;

use Plack::Builder;
use Plack::Request;

use Plync::User;
use Plync::HTTPException;
use Plync::Dispatcher;

our $VERSION = '0.001000';

use overload q(&{}) => sub { shift->psgi_app }, fallback => 1;

sub new {
    my $class = shift;

    my $self = {@_};
    bless $self, $class;

    return $self;
}

sub app {
    my $self = shift;

    return sub {
        my $env = shift;

        return $self->dispatch($env);
    }
}

sub psgi_app {
    my $self = shift;

    return $self->{psgi_app} ||= $self->compile_psgi_app;
}

sub compile_psgi_app {
    my $self = shift;

    builder {
        enable "ContentLength";

        enable "HTTPExceptions";

        enable "Auth::Basic", authenticator => sub {
            my ($username, $password, $env) = @_;

            my $user = Plync::User->load($username);
            return unless $user;

            if ($user->check_password($password)) {
                $env->{'plync.user'} = $user;
                return 1;
            }

            return;
        };

        enable "+Plync::Middleware::WBXML";

        $self->app;
    };
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

    my $body = Plync::Dispatcher->dispatch($req->content);

    if (ref $body eq 'CODE') {
        return sub {
            my $respond = shift;

            $respond->(200, ['Content-Type' => 'text/xml']);

            $body->(
                sub {
                    my $res = shift;

                    my $writer = $respond->write($res);
                    $writer->close;
                }
            );
        }
    }
    else {
        my $res = $req->new_response(200);
        $res->content_type('text/xml');
        $res->body($body);

        return $res->finalize;
    }
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
        [   'MS-Server-ActiveSync'  => '14.00.0536.000',
            'MS-ASProtocolVersions' => '12.1,14.0,14.1',
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
