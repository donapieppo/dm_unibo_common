require "rails/engine"

module DmUniboCommon
  class Engine < ::Rails::Engine
    isolate_namespace DmUniboCommon

    config.generators do |g|
      g.test_framework :rspec
      g.fixture_replacement :factory_bot
      g.factory_bot dir: 'spec/factories'
    end 

    initializer "dm_unibo_common.assets.precompile" do |app|
      app.config.assets.precompile += %w( dm_unibo_common/unibo.png dm_unibo_common/ssologo18x18.png ) 
    end
  end
end


