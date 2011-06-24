package Plync;

use strict;
use warnings;

use AnyEvent;
use File::Basename ();
use File::Spec;
use MIME::Base64;
use Plack::Builder;
use Plack::Request;

use Plync::Backend;
use Plync::Config;
use Plync::DevicePool;
use Plync::Dispatcher;
use Plync::HTTPException;
use Plync::Storage;
use Plync::UserManager;

our $VERSION = '0.001000';

our $HOME;

use overload q(&{}) => sub { shift->psgi_app }, fallback => 1;

sub new {
    my $class = shift;

    my $self = {@_};
    bless $self, $class;

    $self->{user_manager} ||= Plync::UserManager->new;

    $self->_load_config;

    return $self;
}

sub import {
    $HOME = File::Spec->rel2abs(File::Basename::dirname((caller)[1]));
}

sub app {
    my $self = shift;

    return sub {
        my $env = shift;

        return sub {
            my $respond = shift;

            $self->authorize(
                $env, $respond,
                $self->authorization_succeeded($env),
                $self->authorization_failed($env)
            );
        }
    }
}

# Basic authorization methods borrowed from Plack::Middleware::Auth::Basic
sub authorize {
    my $self = shift;
    my ($env, $respond, $ok_cb, $error_cb) = @_;

    my $auth = $env->{HTTP_AUTHORIZATION} or return $error_cb->($respond);

    if ($auth =~ /^Basic (.*)$/) {
        my($username, $password) = split /:/, (MIME::Base64::decode($1) || ":");
        $password = '' unless defined $password;

        return $self->{user_manager}->authorize(
            $username,
            $password,
            sub {
                my $user = $_[1];

                $env->{REMOTE_USER} = $username;
                $env->{'plync.user'} = $user;

                $ok_cb->($respond);
            },
            sub { $error_cb->($respond) }
        );
    }

    return $error_cb->($respond);
}

sub authorization_succeeded {
    my $self = shift;
    my ($env) = @_;

    return sub {
        my $respond = shift;

        $self->dispatch($env, $respond);
    }
}

sub authorization_failed {
    my $self = shift;
    my ($env) = @_;

    return sub {
        my $respond = shift;

        my $body = 'Authorization required';

        $respond->(
            [   401,
                [   'Content-Type'     => 'text/plain',
                    'Content-Length'   => length $body,
                    'WWW-Authenticate' => 'Basic realm="Authorization required"'
                ],
                [$body]
            ]
        );
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

        enable "+Plync::Middleware::WBXML";

        $self->app;
    };
}

sub dispatch {
    my $self = shift;
    my ($env, $respond) = @_;

    my $req = Plack::Request->new($env);

    return $respond->($self->_dispatch_OPTIONS) if $req->method eq 'OPTIONS';

    Plync::HTTPException->throw(400) unless $req->method eq 'POST';

    my $device = $self->_build_device($env);

    my $dispatcher = $self->_build_dispatcher(device => $device);

    my $res = $dispatcher->dispatch($req->content);

    if (ref $res eq 'CODE') {
        $res->(
            sub { $respond->([200, ['Content-Type' => 'text/xml'], $_[0]]) });
    }
    else {
        $respond->([200, ['Content-Type' => 'text/xml'], $res]);
    }
}

sub _build_device {
    my $self = shift;
    my ($env) = @_;

    my $req = Plack::Request->new($env);

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


    my (undef, $device_id, $device_type) = $self->_get_client_info($req);

    my $user     = $env->{'plync.user'};
    my $username = $user->username;

    my $device = Plync::DevicePool->find_device("$username:$device_id");
    if (!$device) {
        $device = Plync::DevicePool->add_device(
            id               => "$username:$device_id",
            type             => $device_type,
            user             => $user,
            backend          => $self->_build_backend(user => $user),
            protocol_version => $protocol_version,
            policy_key       => $policy_key,
            user_agent       => $user_agent
        );
    }

    return $device;
}

sub _build_backend {
    my $self = shift;

    return Plync::Backend->new($self->{backend}, @_);
}

sub _build_dispatcher {
    my $self = shift;

    Plync::Dispatcher->new(@_);
}

sub _dispatch_OPTIONS {
    my $self = shift;

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

sub _load_config {
    my $self = shift;

    my $path = File::Spec->catfile($HOME, 'plync.yml');

    if (-e $path) {
        Plync::Config->load($path);
    }
}

1;
