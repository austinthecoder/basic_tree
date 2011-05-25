# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "basic_tree/version"

Gem::Specification.new do |s|
  s.name = "basic_tree"
  s.version = BasicTree::VERSION
  s.platform = Gem::Platform::RUBY
  s.authors = ["Austin Schneider"]
  s.email = ["soccer022483@gmail.com"]
  s.homepage = "http://github.com/soccer022483/basic_tree"
  s.summary = %q{A basic tree structure.}
  s.description = %q{A basic tree structure.}

  s.rubyforge_project = "basic_tree"

  s.files = `git ls-files`.split("\n")
  s.test_files = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_development_dependency 'rspec', "~> 2.5.0"

  s.add_dependency 'activesupport', ">= 3.0.7"
  s.add_dependency 'i18n', ">= 0.6.0"
end