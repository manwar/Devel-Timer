use inc::Module::Install;
use strict;
use warnings;
use 5.006;

name           'Devel-Timer';
all_from       'lib/Devel/Timer.pm';
license        'perl';
author         'Jason Moore';

build_requires 'Test::More'                => '0.42';

requires 'perl'         => '5.006';
requires 'Time::HiRes'  => '0';

repository 'https://github.com/szabgab/Devel-Timer';

WriteAll;


