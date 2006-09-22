package Devel::Timer;
use strict;
use warnings;

use Time::HiRes();

our $VERSION = "0.03";

##
## instantiate (and initialize) timer object
##

sub new
{
    my $class = shift;
    my $self = {    
                times => [],
                count => 0,
                label => {},        ## index:label
                };

    bless $self, $class;

    $self->initialize();

    $self->mark("INIT");

    return $self;
}

##
## mark time (w/ optional label)
##

sub mark
{
    my($self, $label) = @_; 

    $label = '' if (!defined($label));

    my $t = [ Time::HiRes::gettimeofday() ];

    my $last_time;
    if ($self->{count} == 0)        ## first time has no last time
    {
        $last_time = $t;
    }
    else
    {
        $last_time = $self->{times}->[($self->{count}-1)];
    }

    ## save time for final report

    push(@{$self->{times}}, $t);                

    ## save time interval 

    my $interval = {    value => Time::HiRes::tv_interval($last_time, $t),
                        index => $self->{count},
                        };
    push(@{$self->{intervals}}, $interval);

    ## save label in separate hash for fast lookup

    $self->{label}->{$self->{count}} = $label;

    $self->{count}++;
}


##
## output report to error log
##

sub report
{
    my $self = shift;

    ## calculate total time (start time vs last time)

    my $total_time = Time::HiRes::tv_interval($self->{times}->[0], $self->{times}->[$self->{count}-1]);

    $self->print("\n");
    $self->print(ref($self) . " Report -- Total time: " . sprintf("%.4f", $total_time) . " secs");
    $self->print("Interval  Time    Percent");
    $self->print("----------------------------------------------");

    ## sort interval structure based on value

    @{$self->{intervals}} = sort { $b->{value} <=> $a->{value} } @{$self->{intervals}};

    ##
    ## report of each time space between marks
    ##

    my $i;
    for $i (@{$self->{intervals}})
    {
        ## skip first time (to make an interval, 
        ## compare the current time with the previous one)

        next if ($i->{index} == 0);

        my $msg = sprintf("%02d -> %02d  %.4f  %5.2f%%  %s -> %s", 
            ($i->{index}-1), $i->{index}, $i->{value}, (($i->{value}/$total_time)*100), 
            $self->{label}->{($i->{index}-1)}, $self->{label}->{$i->{index}});

        $self->print($msg);
    }
}

## output methods
## note: if you want to send output to somewhere other than stderr,
##       you can override the print() method below.  The initialize()
##       and shutdown() methods are provided in case you need to open a file
##       or connect to a database before printing the report.
##       See pod for an example.

sub initialize
{
}

sub print
{
    my($self, $msg) = @_;
    print STDERR $msg . "\n";
}

sub shutdown
{
}

sub DESTROY
{
    my $self = shift;
    $self->shutdown();
}

1;

__END__

=head1 NAME

Devel::Timer - Track and report execution time for parts of code

=head1 SYNOPSIS

  use Devel::Timer;

  my $t = Devel::Timer->new();

  $t->mark("first db query");

  ## do some work

  $t->mark("second db query");

  ## do some more work

  $t->mark("end of second db query");

  $t->report();

=head1 DESCRIPTION

Devel::Timer allows developers to accurately time how long a specific
piece of code takes to execute.  This can be helpful in locating the
slowest parts of an existing application.

First, the Devel::Timer module is used and instantiated.

  use Devel::Timer;

  my $t = Devel::Timer->new();

Second, markers are placed before and after pieces of code that need to be
timed.  For this example, we are profiling the methods get_user_score() and
get_average_user_score().

  $t->mark("first db query");
  &get_user_score($user);

  $t->mark("second db query");
  &get_average_user_score();

Finally, at the end of the code that you want to profile, and end marker
is place, and a report is generated on stderr.

  $t->mark("END");
  $t->report();

Sample report:

  Devel::Timer Report -- Total time: 0.3464 secs
  Interval  Time    Percent
  ----------------------------------------------
  02 -> 03  0.3001  86.63%  second db query -> END
  01 -> 02  0.0461  13.30%  first db query -> second db query
  00 -> 01  0.0002   0.07%  INIT -> first db query

The report is output using the method Devel::Timer::print() which currently
just prints to stderr.  If you want to send the output to a custom location
you can override the print() method.  The initialize() and shutdown() methods
can also overridden if you want to open and close log files or database
connections.

=head1 Methods

=head2 new

Create a new instance. No parameters are processed.

=head2 initialize

Empty method. Can be implemented in the subclass.

=head2 mark(NAME)

Set a timestamp with a NAME.

=head2 print

Prints to the standar error. Can be overridden in the subclass.

=head2 report

Generates the report. Prints using the B<print> method.

=head2 shutdown

Empty method. Can be implemented in subclass.

=head1 Subclassing

e.g.

package MyTimer;

use strict;
use Devel::Timer;
use vars qw(@ISA);

@ISA = ("Devel::Timer");

sub initialize
{
    my $log = "/tmp/timer.log";
    open(LOG, ">>$log") or die("Unable to open [$log] for writing.");
}

sub print
{
    my($self, $msg) = @_;
    print LOG $msg . "\n";
}

sub shutdown
{
    close LOG;
}

You would then use the new module MyTimer exactly as you would use 
Devel::Timer.

  use MyTimer;
  my $t = MyTimer->new();
  $t->mark("about to do x");
  $t->mark("about to do y");
  $t->mark("done y");
  $t->report();

=head1 SEE ALSO

Time::HiRes

=head1 Copyright

Jason Moore

This is free software.
It is licensed under the same terms as Perl itself.

=head1 AUTHOR

  Jason Moore - jmoore@sober.com

  Maintainer: Gabor Szabo - gabor@pti.co.il

=cut

