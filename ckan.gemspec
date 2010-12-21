# -*- encoding: utf-8 -*-
require File.expand_path("../lib/ckan/version", __FILE__)

Gem::Specification.new do |s|
  s.name        = "ckan"
  s.version     = CKAN::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Aleksander Pohl"]
  s.email       = ["apohllo@o2.pl"]
  s.homepage    = "http://github.com/apohllo/ckan"
  s.summary     = "Ruby Client for Comprehensive Knowledge Archive Network"
  s.description = "Ruby Client for Comprehensive Knowledge Archive Network. Allows for querying the CKAN repository using REST API"

  s.required_rubygems_version = ">= 1.3.6"
  s.rubyforge_project         = "ckan"

  s.add_development_dependency "bundler", ">= 1.0.0"

  s.files        = `git ls-files`.split("\n")
  s.executables  = `git ls-files`.split("\n").map{|f| f =~ /^bin\/(.*)/ ? $1 : nil}.compact
  s.require_path = 'lib'
  s.rdoc_options = ["--main", "README.txt"]
  s.has_rdoc = true
  s.extra_rdoc_files = ["README.txt"]
end
