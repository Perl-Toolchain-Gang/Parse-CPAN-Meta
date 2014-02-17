requires "CPAN::Meta::YAML" => "0.011";
requires "Carp" => "0";
requires "Encode" => "0";
requires "Exporter" => "0";
requires "File::Spec" => "0.80";
requires "JSON::PP" => "2.27200";
requires "PerlIO::encoding" => "0";
requires "perl" => "5.008001";
requires "strict" => "0";

on 'test' => sub {
  requires "ExtUtils::MakeMaker" => "0";
  requires "File::Spec" => "0.80";
  requires "File::Spec::Functions" => "0";
  requires "List::Util" => "0";
  requires "Test::More" => "0.47";
  requires "lib" => "0";
  requires "vars" => "0";
  requires "version" => "0";
  requires "warnings" => "0";
};

on 'test' => sub {
  recommends "CPAN::Meta" => "0";
  recommends "CPAN::Meta::Requirements" => "2.120900";
};

on 'configure' => sub {
  requires "ExtUtils::MakeMaker" => "6.30";
};

on 'develop' => sub {
  requires "Dist::Zilla" => "5.013";
  requires "Dist::Zilla::Plugin::DualLife" => "0";
  requires "Dist::Zilla::Plugin::Encoding" => "0";
  requires "Dist::Zilla::Plugin::MakeMaker" => "0";
  requires "Dist::Zilla::Plugin::MakeMaker::Highlander" => "0.003";
  requires "Dist::Zilla::Plugin::Prereqs" => "0";
  requires "Dist::Zilla::PluginBundle::DAGOLDEN" => "0.053";
  requires "File::Spec" => "0";
  requires "File::Temp" => "0";
  requires "IO::Handle" => "0";
  requires "IPC::Open3" => "0";
  requires "Pod::Coverage::TrustPod" => "0";
  requires "Test::CPAN::Meta" => "0";
  requires "Test::More" => "0";
  requires "Test::Pod" => "1.41";
  requires "Test::Pod::Coverage" => "1.08";
};
