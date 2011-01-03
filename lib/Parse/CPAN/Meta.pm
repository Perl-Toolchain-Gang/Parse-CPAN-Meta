package Parse::CPAN::Meta;

use strict;
use Carp 'croak';
use Module::Load::Conditional qw/can_load/;

# UTF Support?
sub HAVE_UTF8 () { $] >= 5.007003 }
sub IO_LAYER () { $] >= 5.008001 ? ":utf8" : "" }  

BEGIN {
	if ( HAVE_UTF8 ) {
		# The string eval helps hide this from Test::MinimumVersion
		eval "require utf8;";
		die "Failed to load UTF-8 support" if $@;
	}

	# Class structure
	require 5.004;
	require Exporter;
	$Parse::CPAN::Meta::VERSION   = '1.41_04';
	@Parse::CPAN::Meta::ISA       = qw{ Exporter      };
	@Parse::CPAN::Meta::EXPORT_OK = qw{ Load LoadFile };
}

sub load_file {
  my ($class, $filename) = @_;

  if ($filename =~ /\.ya?ml$/) {
    return $class->load_yaml_string(_slurp($filename));
  }

  if ($filename =~ /\.json$/) {
    return $class->load_json_string(_slurp($filename));
  }

  croak("file type cannot be determined by filename");
}

my $yaml_version; # cache the check
sub load_yaml_string {
  my ($class, $string) = @_;
  require CPAN::Meta::YAML;
  $yaml_version ||= CPAN::Meta::YAML->VERSION(0.002);
  my $yaml = CPAN::Meta::YAML->read_string($string)
    or die CPAN::Meta::YAML->errstr;
  return $yaml->[-1] || {};
}

sub load_json_string {
  my ($class, $string) = @_;
  my $json_class = _choose_json_backend();
  return $json_class->new->utf8->decode($string);
}

sub _choose_json_backend {
  local $Module::Load::Conditional::CHECK_INC_HASH = 1;
  
  # default to JSON::PP
  my $backend = exists $ENV{PERL_JSON_BACKEND} ? $ENV{PERL_JSON_BACKEND} : '0';

  if ($backend eq '0' or $backend eq 'JSON::PP') {
    can_load( modules => {'JSON::PP' => 2.27103}, verbose => 0 )
      or die "JSON::PP 2.27103 is not available\n";
    return 'JSON::PP';
  }
  else {
    can_load( modules => {'JSON' => 2.5}, verbose => 0 )
      or die "JSON 2.5 is required for PERL_JSON_BACKEND";
    return "JSON";
  }
}

sub _slurp {
  open my $fh, "<" . IO_LAYER, "$_[0]"
    or die "can't open $_[0] for reading: $!";
  return do { local $/; <$fh> };
}
  
# Kept for backwards compatibility only
# Create an object from a file
sub LoadFile ($) {
  require CPAN::Meta::YAML;
  return CPAN::Meta::YAML::LoadFile(shift)
    or die CPAN::Meta::YAML->errstr;
}

# Parse a document from a string.
sub Load ($) {
  require CPAN::Meta::YAML;
  return CPAN::Meta::YAML::Load(shift)
    or die CPAN::Meta::YAML->errstr;
}

1;

__END__

=pod

=head1 NAME

Parse::CPAN::Meta - Parse META.yml and other similar CPAN metadata files

=head1 SYNOPSIS

    #############################################
    # In your file
    
    ---
    name: My-Distribution
    version: 1.23
    resources:
      homepage: "http://example.com/dist/My-Distribution"
    
    
    #############################################
    # In your program
    
    use Parse::CPAN::Meta;
    
    my $distmeta = Parse::CPAN::Meta->load_file('META.yml');
    
    # Reading properties
    my $name     = $distmeta->{name};
    my $version  = $distmeta->{version};
    my $homepage = $distmeta->{resources}{homepage};

=head1 DESCRIPTION

B<Parse::CPAN::Meta> is a parser for F<META.json> and F<META.yml> files, using
L<JSON::PP> and/or L<CPAN::Meta::YAML>.

B<Parse::CPAN::Meta> provides three methods: C<load_file>, C<load_json_string>,
and C<load_yaml_string>.  These will read and deserialize CPAN metafiles, and
are described below in detail.

B<Parse::CPAN::Meta> provides a legacy API of only two functions,
based on the YAML functions of the same name. Wherever possible,
identical calling semantics are used.

All error reporting is done with exceptions (die'ing).

Note that META files are expected to be in UTF-8 encoding, only.

=head1 METHODS

=head2 load_file

  my $metadata_structure = Parse::CPAN::Meta->load_file('META.json');

  my $metadata_structure = Parse::CPAN::Meta->load_file('META.yml');

This method will read the named file and deserialize it to a data structure,
determining whether it should be JSON or YAML based on the filename.

=head2 load_yaml_string

  my $metadata_structure = Parse::CPAN::Meta->load_yaml_string( $yaml_string);

This method deserializes the given string of YAML and returns the first
document in it.  (CPAN metadata files should always have only one document.)

=head2 load_json_string

  my $metadata_structure = Parse::CPAN::Meta->load_json_string( $json_string);

This method deserializes the given string of JSON and the result. By default,
L<JSON::PP> will be used. If the C<PERL_JSON_BACKEND> environment variable
exists and is set to anything other than "0" or "JSON::PP", then the L<JSON>
module (version 2.5 or greater) will be loaded and used; if L<JSON> is not
installed or is too old, an exception will be thrown.

=head1 FUNCTIONS

For maintenance clarity, no functions are exported.  These functions are
available for backwards compatibility only and are best avoided in favor of
C<load_file>.

=head2 Load

  my @yaml = Parse::CPAN::Meta::Load( $string );

Parses a string containing a valid YAML stream into a list of Perl data
structures.

=head2 LoadFile

  my @yaml = Parse::CPAN::Meta::LoadFile( 'META.yml' );

Reads the YAML stream from a file instead of a string.

=head1 SUPPORT

Bugs should be reported via the CPAN bug tracker at

L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Parse-CPAN-Meta>

=head1 AUTHOR

Adam Kennedy E<lt>adamk@cpan.orgE<gt>

=head1 COPYRIGHT

Copyright 2006 - 2010 Adam Kennedy.

This program is free software; you can redistribute
it and/or modify it under the same terms as Perl itself.

The full text of the license can be found in the
LICENSE file included with this module.

=cut
