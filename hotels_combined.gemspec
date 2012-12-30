# -*- encoding: utf-8 -*-
require File.expand_path('../lib/hotels_combined/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Zack Hovatter"]
  gem.email         = ["zackhovatter@gmail.com"]
  gem.description   = %q{Ruby client for the HotelsCombined API}
  gem.summary       = %q{Ruby client for the HotelsCombined API}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "hotels_combined"
  gem.require_paths = ["lib"]
  gem.version       = HotelsCombined::VERSION

  gem.add_development_dependency "rspec", "~> 2.11.0"
  gem.add_development_dependency "vcr", "~> 2.3.0"
  gem.add_development_dependency "webmock", "~> 1.8.0"
  gem.add_runtime_dependency "nokogiri", "~> 1.5.5"
  gem.add_runtime_dependency "chronic", "~> 0.9.0"
end
