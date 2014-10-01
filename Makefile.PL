use inc::Module::Install;
use strict;
use warnings;
use 5.006;

name           'Devel-Timer';
all_from       'lib/Devel/Timer.pm';
license        'perl';
author         'Jason Moore';

build_requires 'Test::More'                => '1.00';
build_requires 'Capture::Tiny'             => '0.25';

requires 'perl'         => '5.006';
requires 'Time::HiRes'  => '0';

repository 'https://github.com/szabgab/Devel-Timer';

WriteAll;


