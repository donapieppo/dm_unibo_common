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

  s.add_dependency 'rails', '~> 5.2.0'
  s.add_dependency 'mysql2'
  s.add_dependency 'sassc-rails'
  s.add_dependency 'bootsnap'
  s.add_dependency 'mini_magick'

  # unibo
  # s.add_dependency 'dm_unibo_user_search', '= 0.1.0'

  # auth
  s.add_dependency 'omniauth'
  s.add_dependency 'omniauth-shibboleth'
  s.add_dependency 'omniauth-google-oauth2'  
  # auth - inpersonation 
  s.add_dependency 'pretender'
  # standard rails
  s.add_dependency 'uglifier'
  s.add_dependency 'coffee-rails'
  s.add_dependency 'jquery-rails'
  s.add_dependency 'jbuilder'
  # style 
  s.add_dependency 'simple_form', '~> 4'
  s.add_dependency 'bootstrap', '~> 4'
  # s.add_dependency 'bh', '~> 1.3'
  s.add_dependency 'font-awesome-sass'

  s.add_dependency 'listen', '~> 3.0.5'
  
  s.add_development_dependency 'sqlite3'
  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'factory_bot_rails'
  s.add_development_dependency 'database_cleaner'
  s.add_development_dependency 'capybara'
  # s.add_development_dependency 'selenium-webdriver'
end

# Development dependencies aren't installed by default and aren't activated when a gem is required.
#
