use strict;
use warnings;

use 5.008001;

use ExtUtils::MakeMaker;

my %WriteMakefileArgs = (
  "ABSTRACT" => "Parse META.yml and META.json CPAN metadata files",
  "AUTHOR" => "Adam Kennedy <adamk\@cpan.org>, David Golden <dagolden\@cpan.org>",
  "CONFIGURE_REQUIRES" => {
    "ExtUtils::MakeMaker" => 0
  },
  "DISTNAME" => "Parse-CPAN-Meta",
  "LICENSE" => "perl",
  "MIN_PERL_VERSION" => "5.008001",
  "NAME" => "Parse::CPAN::Meta",
  "PREREQ_PM" => {
    "CPAN::Meta::YAML" => "0.011",
    "Carp" => 0,
    "Encode" => 0,
    "Exporter" => 0,
    "File::Spec" => "0.80",
    "JSON::PP" => "2.27200",
    "strict" => 0
  },
  "TEST_REQUIRES" => {
    "ExtUtils::MakeMaker" => 0,
    "File::Spec" => "0.80",
    "File::Spec::Functions" => 0,
    "JSON::PP" => "2.27200",
    "Test::More" => "0.47",
    "lib" => 0,
    "vars" => 0,
    "warnings" => 0
  },
  "VERSION" => "1.4418",
  "test" => {
    "TESTS" => "t/*.t"
  }
);


my %FallbackPrereqs = (
  "CPAN::Meta::YAML" => "0.011",
  "Carp" => 0,
  "Encode" => 0,
  "Exporter" => 0,
  "ExtUtils::MakeMaker" => 0,
  "File::Spec" => "0.80",
  "File::Spec::Functions" => 0,
  "JSON::PP" => "2.27200",
  "Test::More" => "0.47",
  "lib" => 0,
  "strict" => 0,
  "vars" => 0,
  "warnings" => 0
);


unless ( eval { ExtUtils::MakeMaker->VERSION(6.63_03) } ) {
  delete $WriteMakefileArgs{TEST_REQUIRES};
  delete $WriteMakefileArgs{BUILD_REQUIRES};
  $WriteMakefileArgs{PREREQ_PM} = \%FallbackPrereqs;
}

delete $WriteMakefileArgs{CONFIGURE_REQUIRES}
  unless eval { ExtUtils::MakeMaker->VERSION(6.52) };

# Added by Dist::Zilla::Plugin::MakeMaker::Highlander
if ( $] < 5.012
  && ! $ENV{PERL_NO_HIGHLANDER}
  && ! ( $ENV{PERL_MM_OPT} && $ENV{PERL_MM_OPT} =~ /(?:INSTALL_BASE|PREFIX)/ )
  && ! grep { /INSTALL_BASE/ || /PREFIX/ } @ARGV
) {
    $WriteMakefileArgs{UNINST} = 1;
}

$WriteMakefileArgs{INSTALLDIRS} = 'perl'
    if $] >= 5.010001 && $] <= 5.011000;

WriteMakefile(%WriteMakefileArgs);
