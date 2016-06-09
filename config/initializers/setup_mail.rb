ActionMailer::Base.smtp_settings = { address: DmUniboCommon::SMTP_ADDRESS, domain: DmUniboCommon::SMTP_DOMAIN }
ActionMailer::Base.register_interceptor(DmUniboCommon::DevelopmentMailInterceptor) 
Rails.application.routes.default_url_options[:host] = Rails.env.production? ? DmUniboCommon::HOST : DmUniboCommon::HOST_TEST

