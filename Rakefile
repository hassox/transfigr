require 'rubygems'
require 'rake/gempackagetask'
require "spec/rake/spectask"

GEM_NAME = "transfigr"
GEM_VERSION = "0.1.0"
AUTHOR = "Daniel Neighman"
EMAIL = "has.sox@gmail.com"
HOMEPAGE = "http://rubunity.com"
SUMMARY = "A Pluggable Markup Formatter"

spec = Gem::Specification.new do |s|
  s.rubyforge_project = 'transfigr'
  s.name = GEM_NAME
  s.version = GEM_VERSION
  s.platform = Gem::Platform::RUBY
  s.has_rdoc = true
  s.extra_rdoc_files = ["README.textile", "LICENSE", 'TODO']
  s.summary = SUMMARY
  s.description = s.summary
  s.author = AUTHOR
  s.email = EMAIL
  s.homepage = HOMEPAGE
  s.require_path = 'lib'
  s.files = %w(LICENSE README.textile Rakefile TODO) + Dir.glob("{lib,spec}/**/*")
end

Rake::GemPackageTask.new(spec) do |pkg|
  pkg.gem_spec = spec
end

desc "Install the gem"
task :install => [:clobber_package, :package] do
  system "gem install pkg/transfigr-#{GEM_VERSION}.gem"
end

desc "Run all specs"
Spec::Rake::SpecTask.new("spec") do |t|
  t.spec_opts = ["--format", "specdoc", "--colour"]
  t.spec_files = Dir["spec/**/*_spec.rb"].sort
  t.rcov = false
  t.rcov_opts << '--sort' << 'coverage' << '--sort-reverse'
  t.rcov_opts << '--only-uncovered'
end