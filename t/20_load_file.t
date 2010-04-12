#!/usr/bin/perl

# Testing of a known-bad file from an editor

BEGIN {
	if( $ENV{PERL_CORE} ) {
		chdir 't';
		@INC = ('../lib', 'lib');
	}
	else {
		unshift @INC, 't/lib/';
	}
}

use strict;
BEGIN {
	$|  = 1;
	$^W = 1;
}

use File::Spec::Functions ':ALL';
use Parse::CPAN::Meta::Test;
# use Test::More skip_all => 'Temporarily ignoring failing test';
use Test::More 'no_plan';





#####################################################################
# Testing that Perl::Smith config files work

my $want = {
  "abstract" => "a set of version requirements for a CPAN dist",
  "author"   => [ 'Ricardo Signes <rjbs@cpan.org>' ],
  "build_requires" => {
     "Test::More" => "0.88"
  },
  "configure_requires" => {
     "ExtUtils::MakeMaker" => "6.31"
  },
  "generated_by" => "Dist::Zilla version 2.100991",
  "license" => "perl",
  "meta-spec" => {
     "url" => "http://module-build.sourceforge.net/META-spec-v1.4.html",
     "version" => 1.4
  },
  "name" => "Version-Requirements",
  "recommends" => {},
  "requires" => {
     "Carp" => "0",
     "Scalar::Util" => "0",
     "version" => "0.77"
  },
  "resources" => {
     "repository" => "git://git.codesimply.com/Version-Requirements.git"
  },
  "version" => "0.101010",
};

my $meta_yaml = catfile( test_data_directory(), 'VR-META.yml' );
my $from_yaml = Parse::CPAN::Meta->load_file( $meta_yaml );
is_deeply($from_yaml, $want, "load from YAML results in expected data");

my $meta_json = catfile( test_data_directory(), 'VR-META.json' );
my $from_json = Parse::CPAN::Meta->load_file( $meta_json );
is_deeply($from_json, $want, "load from JSON results in expected data");
