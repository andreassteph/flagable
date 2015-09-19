$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "flagable/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "flagable"
  s.version     = Flagable::VERSION
  s.authors     = ["Andreas Stephanides"]
  s.email       = ["andreas.stephanides@gmx.at"]
  s.homepage    = ""
  s.summary     = "Flagable provides the action flag for controllers and the necessary funcitons for the model for easy flags"
  s.description = "TODO: Description of Flagable."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 3.2.13"

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "rspec"
end
