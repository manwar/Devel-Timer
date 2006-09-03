package MyTimer;

##
## This is an example of how to subclass Devel::Timer
##

use strict;
use Devel::Timer;
use vars qw(@ISA);

@ISA = ("Devel::Timer");

sub initialize
{        
    my $log = "/tmp/timer.log";
    open(my $fh, '>>', $log) or die("Unable to open [$log] for writing.");
}

sub print
{
    my($self, $msg) = @_;
    print {$fh} $msg . "\n";
}

sub close
{
    close $fh;
}

