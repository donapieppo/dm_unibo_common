require_relative "lib/dm_unibo_common/version"

Gem::Specification.new do |spec|
  spec.name = "dm_unibo_common"
  spec.version = DmUniboCommon::VERSION
  spec.authors = ["Pietro Donatini"]
  spec.email = ["pietro.donatini@unibo.it"]
  spec.homepage = ""
  spec.summary = "Common lib for DM UNIBO"
  spec.description = "Css/scss js etc etc for use in DM UNIBO projects."
  spec.license = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the "allowed_push_host"
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  end

  spec.add_dependency "rails", "< 8.0"
  spec.add_dependency "sprockets-rails"
  spec.add_dependency "mysql2", "~> 0.5"
  spec.add_dependency "puma", "~> 6.4"
  spec.add_dependency "rack", "~> 3.1"
  spec.add_dependency "importmap-rails"
  spec.add_dependency "jbuilder"
  spec.add_dependency "turbo-rails"
  spec.add_dependency "stimulus-rails"
  spec.add_dependency "view_component"
  spec.add_dependency "jsbundling-rails"
  spec.add_dependency "cssbundling-rails"
  spec.add_dependency "bootsnap"
  spec.add_dependency "lograge"

  spec.add_dependency "omniauth"
  spec.add_dependency "omniauth-entra-id"
  spec.add_dependency "omniauth-shibboleth"
  spec.add_dependency "omniauth-google-oauth2"
  spec.add_dependency "omniauth-rails_csrf_protection"
  spec.add_dependency "pretender"
  spec.add_dependency "pundit"
  spec.add_dependency "simple_form", "~> 5.3"
end
