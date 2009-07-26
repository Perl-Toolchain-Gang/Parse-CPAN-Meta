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

# ExtUtil::MakeMaker's default PMLIBDIRS finds uupacktool.pl but
# that's only a utility so I'd like it to be skipped over.
sub libscan {
	my $self = shift @_;
	my ( $pl_or_pm ) = @_;
	return 0 if $pl_or_pm eq 'uupacktool.pl';
	return $self->SUPER::libscan( @_ );
}

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
