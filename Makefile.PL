use strict;
BEGIN {
	require 5.003_96;
	$main::VERSION = '0.01';
}
use ExtUtils::MakeMaker;

my $PREREQ_PM = {
	# Skip on Windows to avoid breaking ActivePerl PPMs
	# Both come with 5.6.2 or newer, which everyone on Win32 has.
	($^O eq 'MSWin32' ? () : ('File::Spec' => '0.80')),
	($^O eq 'MSWin32' ? () : ('Test::More' => '0.47')),
};

WriteMakefile(
	NAME      => 'Parse::CPAN::Meta',
	ABSTRACT  => 'Parse META.yml and other similar CPAN metadata files',
	VERSION   => $main::VERSION,
	PREREQ_PM => {
		File::Spec => '0.80',
		Test::More => '0.47',
	},
	($] >= 5.005 ? (
		AUTHOR  => 'Adam Kennedy <adamk@cpan.org>',
	) : ()),
	($ExtUtils::MakeMaker::VERSION ge '6.30_00' ? (
		LICENSE => 'perl',
	) : ()),
	(INSTALLDIRS => $] >= 5.010001 ? 'perl' : 'site'),
);
