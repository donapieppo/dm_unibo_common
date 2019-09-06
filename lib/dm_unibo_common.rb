require "dm_unibo_common/engine"

# rails
require 'mysql2'
require 'jquery-rails'
require 'sassc-rails'
require 'bootstrap'

# auth
require 'omniauth'
require 'omniauth-shibboleth'
require 'omniauth-google-oauth2'  
require 'pretender'
require 'pundit'

require 'font-awesome-sass'

# self
require 'dm_unibo_common/errors'
require 'dm_unibo_common/development_mail_interceptor'
require 'dm_unibo_common/user'
require 'dm_unibo_common/user_upn_methods'
require 'dm_unibo_common/controllers/helpers'

module DmUniboCommon
end

# http://guides.rubyonrails.org/engines.html
