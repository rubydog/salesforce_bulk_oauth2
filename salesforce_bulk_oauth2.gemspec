# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "lib/version"

Gem::Specification.new do |s|
  s.name        = "salesforce_bulk_oauth2"
  s.version     = SalesforceBulk::VERSION
  s.authors     = ["Bhushan Lodha"]
  s.email       = ["bhushanlodha@gmail.com"]
  s.homepage    = "https://github.com/bhushan/salesforce_bulk_oauth2"
  s.summary     = %q{Ruby support for the Salesforce Bulk API using Oauth2}
  s.description = %q{This gem provides a super simple interface for the Salesforce Bulk API through Oauth2. It provides support for insert, update, upsert, delete, and query.}

 # s.rubyforge_project = "salesforce_bulk"

  s.files         = Dir['README.rdoc', 'lib/**/*']
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  # s.add_development_dependency "rspec"
  # s.add_runtime_dependency "rest-client"

  s.add_dependency "xml-simple"
  s.add_dependency "databasedotcom"

end
