use strict;
use warnings;
use Test::More tests => 2;


use lib 'eg';
use_ok('MyTimer');

my $t = MyTimer->new;
isa_ok($t, 'MyTimer');

