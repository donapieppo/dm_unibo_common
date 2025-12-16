require "dm_unibo_common/version"
require "dm_unibo_common/engine"

# rails
require "mysql2"

# auth
require "omniauth"
require "pretender"
require "pundit"
require "view_component"
require "turbo-rails"
require "stimulus-rails"
require "simple_form"
require "sprockets/railtie"
require "lograge"
require "propshaft/railtie"

# self
require "dm_unibo_common/errors"
require "dm_unibo_common/development_mail_interceptor"
require "dm_unibo_common/user"
require "dm_unibo_common/organization"
require "dm_unibo_common/authorization"
require "dm_unibo_common/user_upn_methods"
require "dm_unibo_common/controllers/helpers"

module DmUniboCommon
end

# http://guides.rubyonrails.org/engines.html
