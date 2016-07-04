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

  s.add_dependency 'rails', '~> 4.2.6'
  s.add_dependency 'mysql2', '~> 0.3.18'

  # auth
  s.add_dependency 'devise'
  s.add_dependency 'devise-i18n'
  s.add_dependency 'omniauth'
  s.add_dependency 'omniauth-shibboleth'
  s.add_dependency 'omniauth-google-oauth2'  
  # auth - inpersonation 
  s.add_dependency 'pretender'
  # standard rails
  s.add_dependency 'uglifier', '>= 1.3.0'
  s.add_dependency 'coffee-rails', '~> 4.1.0'
  s.add_dependency 'sass-rails', '>= 5.0.3'
  s.add_dependency 'jquery-rails'
  s.add_dependency 'jbuilder', '~> 2.0'
  # style 
  s.add_dependency 'simple_form'
  s.add_dependency 'bootstrap-sass'
  # s.add_dependency 'bh', '~> 1.3'
  s.add_dependency 'font-awesome-sass'
  # only in unibo env
  if File.file?('/etc/unibo/dsa_search.yml')
    s.add_dependency 'dsa_search'
  end
  
  s.add_development_dependency 'sqlite3'
  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'factory_girl_rails'
  s.add_development_dependency 'database_cleaner'
end

# Development dependencies aren't installed by default and aren't activated when a gem is required.
#
