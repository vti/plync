package Plync::Middleware::WBXML;

use strict;
use warnings;

use base 'Plack::Middleware';

use constant DEBUG => $ENV{PLYNC_DEBUG};

use Plack::Util ();
use Plack::Request;

use Plync::HTTPException;
use Plync::WBXML::Builder;
use Plync::WBXML::Parser;
use Plync::WBXML::Schema::ActiveSync;

use Try::Tiny;

sub call {
    my ($self, $env) = @_;

    my $req = Plack::Request->new($env);

    if ($req->method ne 'POST') {
        return $self->app->($env);
    }

    my $dom = $self->_parse($req->content);

    $env->{'CONTENT_LENGTH'} = length($dom->toString);
    $env->{'psgi.input'} = Plync::Middleware::WBXML::Handle->new(dom => $dom);

    my $res = $self->app->($env);

    Plack::Util::response_cb(
        $res,
        sub {
            my $res = shift;

            my $body = $res->[2];
            if (ref $body eq 'ARRAY') {
                $res->[2] = [$self->_build(@$body)];
            }
            elsif (ref $body eq 'XML::LibXML::Document') {
                $res->[2] = [$self->_build($body)];
            }
            else {
                die 'TODO';
            }

            my $headers = Plack::Util::headers($res->[1]);
            $headers->set('Content-Length' => Plack::Util::content_length($res->[2]));
            $headers->set('Content-Type' => 'application/vnd.ms-sync.wbxml');

            $res->[1] = $headers->headers;

            return;
        }
    );
}

sub _parse {
    my $self = shift;
    my ($wbxml) = @_;

    return try {
        my $parser =
          Plync::WBXML::Parser->new(
            schema => Plync::WBXML::Schema::ActiveSync->schema);

        $parser->parse($wbxml);

        if (DEBUG) {
            warn '>' x 20;
            warn $parser->dom->toString(2);
            warn '>' x 20;
        }

        $parser->dom;
    }
    catch {
        Plync::HTTPException->throw(400, message => 'Malformed WBXML');
    };
}

sub _build {
    my $self = shift;
    my ($dom) = @_;

    return try {
        my $builder =
          Plync::WBXML::Builder->new(
            schema => Plync::WBXML::Schema::ActiveSync->schema);
        $builder->build($dom);

        if (DEBUG) {
            warn '<' x 20;
            warn $dom->toString(2);
            warn '<' x 20;
        }

        $builder->to_wbxml;
    }
    catch {
        Plync::HTTPException->throw(500);
    };
}

package Plync::Middleware::WBXML::Handle;

use strict;
use warnings;

sub new {
    my $class = shift;

    my $self = {@_};
    bless $self, $class;

    return $self;
}

sub dom { $_[0]->{dom} }

sub read {
    my $self = shift;

    return $self->_fh->read(@_);
}

sub seek {
    my $self = shift;

    return $self->_fh->seek(@_);
}

sub _fh {
    my $self = shift;

    $self->{fh} ||= do {
        my $string = $self->{dom}->toString;
        open my $fh, '<', \$string;
        return $fh;
    };

    return $self->{fh};
}

1;
