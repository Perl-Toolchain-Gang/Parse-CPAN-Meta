use strict;
BEGIN {
	require 5.003_96;
	$main::VERSION = '1.40';
}
use ExtUtils::MakeMaker;

WriteMakefile(
	NAME      => 'Parse::CPAN::Meta',
	ABSTRACT  => 'Parse META.yml and other similar CPAN metadata files',
	VERSION   => $main::VERSION,
	PREREQ_PM => {
		'File::Spec' => '0.80',
		'Test::More' => '0.47',
	},
	($] >= 5.005 ? (
		AUTHOR  => 'Adam Kennedy <adamk@cpan.org>',
	) : ()),
	($ExtUtils::MakeMaker::VERSION ge '6.30_00' ? (
		LICENSE => 'perl',
	) : ()),
	(INSTALLDIRS => $] >= 5.010001 ? 'perl' : 'site'),
);

package MY;
sub test {
	my $inherited = shift->SUPER::test(@_);
	$inherited =~ s{^test\s*:+\s*(.*)}{
		"test : unpack_files $1";
	}me || die $inherited;
	return $inherited;
}
sub clean {
	my $inherited = shift->SUPER::clean(@_);
	$inherited =~ s{^(clean\s*:.*)}{
		"$1 cleanup_unpacked_files";
	}me || die $inherited;
	return $inherited;
}
sub postamble {
	return <<'MAKE_FRAG';
unpack_files:
	$(FULLPERLRUN) uupacktool.pl -u -m

cleanup_unpacked_files:
	$(FULLPERLRUN) uupacktool.pl -c

MAKE_FRAG
}
