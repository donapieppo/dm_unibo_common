# rails
require 'mysql2'
require 'jquery-rails'
require 'sass-rails'
require 'bootstrap-sass'

# auth
require 'devise'
require 'devise-i18n'
require 'omniauth'
require 'omniauth-shibboleth'
require 'omniauth-google-oauth2'  
require 'pretender'

# style
require 'font-awesome-sass'

# self
require 'dm_unibo_common/errors'
require 'dm_unibo_common/development_mail_interceptor'
require 'dm_unibo_common/user'
require 'dm_unibo_common/user_upn_methods'
require 'dm_unibo_common/controllers/helpers'

module DmUniboCommon
  class Engine < Rails::Engine
  end
end

# http://guides.rubyonrails.org/engines.html
