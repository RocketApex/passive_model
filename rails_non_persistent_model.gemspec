require_relative 'lib/passive_model/version'

Gem::Specification.new do |spec|
  spec.name          = "passive_model"
  spec.version       = PassiveModel::VERSION
  spec.authors       = ["Jey Geethan"]
  spec.email         = ["opensource@rocketapex.com"]

  spec.summary       = %q{For using models without saving to the database}
  spec.description   = %q{Get the benefits of models without having to save them to the database in rails}
  spec.homepage      = "https://github.com/RocketApex/passive_model"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  spec.metadata["allowed_push_host"] = "https://rubygems.org"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/RocketApex/passive_model"
  spec.metadata["changelog_uri"] = "https://github.com/RocketApex/passive_model"

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  end

  spec.require_paths = ["lib"]

  spec.add_dependency "rails", ">= 7.0.0"
end
