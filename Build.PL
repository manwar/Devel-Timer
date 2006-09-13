use strict;
use warnings;
use Module::Build;

my $builder = Module::Build->new(
    module_name         => 'Devel::Timer',
    license             => 'perl',
    dist_author         => 'Gabor Szabo <gabor@pti.co.il>',
    create_makefile_pl  => 'traditional',
    create_readme       => 1,
    requires            => {
        'Time::HiRes'               => '0',
    },
    build_requires      => {
        'Test::More'                => '0.47',
    },
);

$builder->create_build_script();
