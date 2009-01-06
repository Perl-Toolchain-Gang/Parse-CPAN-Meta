#!/usr/bin/env perl
use strict;
use warnings;
use Getopt::Long;

my $diff = 'diff';

my $lib  = 'lib/Parse/CPAN';
my $tlib = 't/lib/Parse/CPAN/Meta';
# local => blead
my %files = (
  "$lib/Meta.pm" => "$lib/Meta.pm",

  "$tlib/Test.pm" => "$tlib/Test.pm",
  "Changes" => "$lib/Meta/Changes",

  (
    map {my $f = "t/$_.t"; ($f, "$lib/Meta/$f")}
    qw( 01_compile 02_basic 03_regression 04_scalar
        11_meta_yml 12_plagger 13_perl_smith 14_yaml_org
        15_multibyte 16_nullrefs 17_toolbar )
  ),
  (
    map {my $f = "t/data/$_"; ($f, "$lib/Meta/$f")}
    qw( HTML-WebDAO.yml multibyte.yml sample.yml
        Template-Provider-Unicode-Japanese.yml
        toolbar.yml vanilla.yml )
  ),
);

sub usage {
  print <<HERE;
Usage: $0 -b /path/to/blead/checkout
Does a diff of various files from here to blead
-r reverses the diff
HERE
  exit(1);
}

my $bleadpath;
my $reverse = 0;
GetOptions(
  'b|blead=s' => \$bleadpath,
  'h|help' => \&usage,
  'r|reverse' => \$reverse,
);

usage() if not defined $bleadpath or not -d $bleadpath;

foreach my $local_file (keys %files) {
  my $blead_file = "$bleadpath/" . $files{$local_file};
  my @cmd = ($diff, '-u');
  if ($reverse) {
    push @cmd, $blead_file, $local_file;
  }
  else {
    push @cmd, $local_file, $blead_file;
  }
  my $result = `@cmd`;
  my $blead_prefix = quotemeta($reverse ? '---' : '+++');
  my $local_prefix = quotemeta($reverse ? '+++' : '---');
  $result =~ s/^($blead_prefix\s*)(\S+)/$1.fix_blead_path($2,$bleadpath)/gme;
  $result =~ s/^($local_prefix\s*)(\S+)/$1.$files{$2}/gme;
  print $result;
}

sub fix_blead_path {
  my $path = shift;
  my $bleadpath = shift;
  $path =~ s/^\Q$bleadpath\E//;
  $path =~ s/^\/+//;
  return $path;
}

