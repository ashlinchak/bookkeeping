$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "bookkeeping/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "bookkeeping"
  s.version     = Bookkeeping::VERSION
  s.authors     = ["Alexander"]
  s.email       = ["ashlinchak@gmail.com"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of Bookkeeping."
  s.description = "TODO: Description of Bookkeeping."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]

  s.add_dependency "rails", "~> 4.2.3"

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "rspec-rails"
  s.add_development_dependency "byebug"
  s.add_development_dependency "pry-byebug"
  s.add_development_dependency "pry-rails"
  s.add_development_dependency "factory_girl_rails"
end
