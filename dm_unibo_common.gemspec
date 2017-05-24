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

  s.add_dependency 'rails', '~> 5.1.1'
  s.add_dependency 'mysql2', '>= 0.3.18', '< 0.5'

  # unibo
  # s.add_dependency 'dm_unibo_user_search', '= 0.1.0'

  # auth
  s.add_dependency 'omniauth'
  s.add_dependency 'omniauth-shibboleth'
  s.add_dependency 'omniauth-google-oauth2'  
  # auth - inpersonation 
  s.add_dependency 'pretender', '~> 0.2'
  # standard rails
  s.add_dependency 'uglifier', '>= 1.3.0'
  s.add_dependency 'coffee-rails', '~> 4.2'
  s.add_dependency 'sass-rails', '~> 5.0'
  s.add_dependency 'jquery-rails'
  s.add_dependency 'jbuilder', '~> 2.5'
  # style 
  s.add_dependency 'simple_form', '~> 3.5.0'
  s.add_dependency 'bootstrap-sass'
  # s.add_dependency 'bh', '~> 1.3'
  s.add_dependency 'font-awesome-sass'

  s.add_dependency 'listen', '~> 3.0.5'
  
  s.add_development_dependency 'sqlite3'
  s.add_development_dependency 'listen', '~> 3.0.5'
  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'factory_girl_rails'
  s.add_development_dependency 'database_cleaner'

  # s.add_development_dependency 'capybara', '~> 2.13'
  # s.add_development_dependency 'selenium-webdriver'
end

# Development dependencies aren't installed by default and aren't activated when a gem is required.
#
