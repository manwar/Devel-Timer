# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl test.pl'

######################### We start with some black magic to print on failure.

# Change 1..1 below to 1..last_test_to_print .
# (It may become useful if the test is moved to ./t subdirectory.)

BEGIN { $| = 1; print "1..5\n"; }
END {print "not ok 1\n" unless $loaded;}
use Devel::Timer;
$loaded = 1;
print "ok 1\n";

my $VERBOSE = 0;
$VERBOSE++ if (grep(/-v/, @ARGV));

######################### End of black magic.

# Insert your test code below (better if it prints "ok 13"
# (correspondingly "not ok 13") depending on the success of chunk 13
# of the test code):

  use Devel::Timer;
  # use MyTimer;

  my $t = new Devel::Timer();
  # my $t = new MyTimer();

  $t->mark("first db query");

  ## do some work
  select(undef, undef, undef, 0.05);
  $t->mark("second db query");

  ## do some more work
  select(undef, undef, undef, 0.3);
  $t->mark("END");

  $t->report();

  print "[output]\n" . $Devel::Timer::OUTPUT if ($VERBOSE);

  ($Devel::Timer::OUTPUT =~ /Total time/) ? (print "ok 2\n") : (print "not ok 2\n");
  ($Devel::Timer::OUTPUT =~ /first db query/) ? (print "ok 3\n") : (print "not ok 3\n");
  ($Devel::Timer::OUTPUT =~ /second db query/) ? (print "ok 4\n") : (print "not ok 4\n");
  ($Devel::Timer::OUTPUT =~ /second db query -> END/) ? (print "ok 5\n") : (print "not ok 5\n");


## override print() so we can capture output

package Devel::Timer;

$Devel::Timer::OUTPUT;

sub print
{
    $Devel::Timer::OUTPUT .= $_[1];
}



