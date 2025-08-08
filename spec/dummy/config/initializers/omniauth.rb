require "omniauth-shibboleth"
require "dm_unibo_common/omniauth/strategies/test"

Rails.application.config.middleware.use OmniAuth::Builder do
  configure do |config|
    config.path_prefix = "/dm_unibo_common/auth"
  end

  if Rails.env.test?
    provider :test
  end
end
