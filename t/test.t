#!/usr/bin/perl

use strict;
use warnings;

use Test::More tests => 5;

use_ok( 'Devel::Timer');

my $VERBOSE = 0;
$VERBOSE++ if (grep(/-v/, @ARGV));

#use Devel::Timer;
# use MyTimer;

{
    close STDERR;
    my $stderr;
    open STDERR, '>', \$stderr or die;

    my $t = Devel::Timer->new();
    # my $t = MyTimer->new();

    $t->mark("first db query");

    ## do some work
    select(undef, undef, undef, 0.05);
    $t->mark("second db query");

    ## do some more work
    select(undef, undef, undef, 0.3);
    $t->mark("END");

    $t->report();

    print "[output]\n$stderr" if ($VERBOSE);

    like($stderr, qr/Total time/);
    like($stderr, qr/first db query/);
    like($stderr, qr/second db query/);
    like($stderr, qr/second db query -> END/);
}

