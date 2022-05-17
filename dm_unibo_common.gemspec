# -*- encoding: utf-8 -*-
$:.push File.expand_path('../lib', __FILE__)
require 'dm_unibo_common/version'

Gem::Specification.new do |s|
  s.name        = 'dm_unibo_common'
  s.version     = DmUniboCommon::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Pietro Donatini"]
  s.email       = ["pietro.donatini@unibo.it"]
  s.homepage    = ""
  s.summary     = %q{Common lib for DM UNIBO}
  s.description = %q{Css Js etc etc for use in DM UNIBO projects}

  s.rubyforge_project = 'dm_unibo_common'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ['lib']

  s.add_dependency "rails", "~> 7.0"
  s.add_dependency "sprockets-rails"
  s.add_dependency "mysql2", "~> 0.5"
  s.add_dependency "puma", "~> 5.0"
  s.add_dependency "importmap-rails"
  s.add_dependency "jbuilder"
  s.add_dependency "turbo-rails"
  s.add_dependency "stimulus-rails"
  s.add_dependency "view_component"
  s.add_dependency "jsbundling-rails"
  s.add_dependency "cssbundling-rails"

  s.add_dependency "image_processing"

  # auth
  s.add_dependency 'omniauth'
  s.add_dependency 'omniauth-shibboleth'
  s.add_dependency 'omniauth-google-oauth2'  
  s.add_dependency 'pretender'
  s.add_dependency 'pundit'
  s.add_dependency 'simple_form'
end

# Development dependencies aren't installed by default and aren't activated when a gem is required.
