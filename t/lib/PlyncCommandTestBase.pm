package PlyncCommandTestBase;

use strict;
use warnings;

use base 'Test::Class';

use Scalar::Util qw(blessed);

sub _run_command {
    my $self = shift;
    my ($command, $in) = @_;

    if (!blessed $command) {
        my $command_class = "Plync::Command::$command";
        eval "require $command_class;" or die $!;
        $command = $command_class->new(device => $self->{device});
    }

    my $cb = $command->dispatch($in);

    my $res;
    if (ref $cb eq 'CODE') {
        $cb->(sub { $res = $_[0] });
    }
    else {
        $res = $cb;
    }

    return $res->toString(2);
}

1;
