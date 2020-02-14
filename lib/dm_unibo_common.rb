require "dm_unibo_common/engine"

# rails
require 'mysql2'

# auth
require 'omniauth'
require 'omniauth-shibboleth'
require 'omniauth-google-oauth2'  
require 'pretender'
require 'pundit'

# self
require 'dm_unibo_common/errors'
require 'dm_unibo_common/development_mail_interceptor'
require 'dm_unibo_common/user'
require 'dm_unibo_common/organization'
require 'dm_unibo_common/authorization'
# require 'dm_unibo_common/permission'
require 'dm_unibo_common/user_upn_methods'
require 'dm_unibo_common/controllers/helpers'
require 'dm_unibo_common/policies/application_policy'
require 'dm_unibo_common/policies/organization_policy'

module DmUniboCommon
end

# http://guides.rubyonrails.org/engines.html
