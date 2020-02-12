module DmUniboCommon
  class Engine < ::Rails::Engine
    # This call is responsible for isolating the controllers, models, routes, and other things into their own namespace
    isolate_namespace DmUniboCommon
  end
end


