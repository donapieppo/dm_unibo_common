ActionMailer::Base.smtp_settings = { address: Rails.configuration.dm_unibo_common[:smtp_address], 
                                     domain:  Rails.configuration.dm_unibo_common[:smtp_domain] }
ActionMailer::Base.register_interceptor(DmUniboCommon::DevelopmentMailInterceptor) 
Rails.application.routes.default_url_options[:host] = Rails.configuration.dm_unibo_common[:host]

