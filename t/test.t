#!/usr/bin/perl

use strict;
use warnings;

use Test::More;
my $tests;
plan tests => $tests;

use_ok( 'Devel::Timer');
BEGIN { $tests += 1; }

{
    close STDERR;
    my $stderr;
    open STDERR, '>', \$stderr or die;

    my $t = _process();
    $t->report();

    like($stderr, qr/Total time/);
    like($stderr, qr/first db query/);
    like($stderr, qr/second db query/);
    like($stderr, qr/second db query -> END/);
    #diag $stderr;
    BEGIN { $tests += 4; }
}

{
    close STDERR;
    my $stderr;
    open STDERR, '>', \$stderr or die;

    my $t = _process();
    $t->report(collapse => 1);
    #diag $stderr;

    ok(1);
    BEGIN { $tests += 1; }
}


sub _process {
    my $t = Devel::Timer->new();

    $t->mark("first db query");

    ## do some more work
    select(undef, undef, undef, 0.7);
    $t->mark();

    ## do some work
    select(undef, undef, undef, 0.05);
    $t->mark("second db query");

    ## do some more work
    select(undef, undef, undef, 0.3);
    $t->mark("END");

    return $t;
}

