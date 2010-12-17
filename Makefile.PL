use strict;
BEGIN {
	require 5.003_96;
	$main::VERSION = '1.41_01';
}
use ExtUtils::MakeMaker;

WriteMakefile(
	NAME      => 'Parse::CPAN::Meta',
	ABSTRACT  => 'Parse META.yml and other similar CPAN metadata files',
	VERSION   => $main::VERSION,
	PREREQ_PM => {
		'JSON::PP'   => 2,
		'File::Spec' => '0.80',
		'Test::More' => '0.47',
		'CPAN::Meta::YAML' => '0.002',
	},
	($] >= 5.005 ? (
		AUTHOR  => 'Adam Kennedy <adamk@cpan.org>',
	) : ()),
	($ExtUtils::MakeMaker::VERSION ge '6.30_00' ? (
		LICENSE => 'perl',
	) : ()),
	(INSTALLDIRS => $] >= 5.010001 ? 'perl' : 'site'),
);

