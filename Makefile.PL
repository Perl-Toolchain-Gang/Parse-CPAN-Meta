use strict;
require 5.003_96;
use ExtUtils::MakeMaker;

WriteMakefile(
	NAME      => 'Parse::CPAN::Meta',
	PREREQ_PM => {
		'File::Spec' => '0.80',
		'Test::More' => '0.47',
		'JSON::PP'   => '2.27200',
		'CPAN::Meta::YAML' => '0.008',
	},
	($] >= 5.005 ? (
		AUTHOR  => 'Adam Kennedy <adamk@cpan.org>',
                ABSTRACT_FROM => 'lib/Parse/CPAN/Meta.pm',
                VERSION_FROM  => 'lib/Parse/CPAN/Meta.pm',
	) : ()),
	($ExtUtils::MakeMaker::VERSION ge '6.30_00' ? (
		LICENSE => 'perl',
	) : ()),
	(INSTALLDIRS => ($] ge '5.010001' && $] lt '5.012') ? 'perl' : 'site'),
);

