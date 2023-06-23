Rails.application.reloader.to_prepare do
  if Rails.configuration.dm_unibo_common[:smtp_unibo] 
    ActionMailer::Base.smtp_settings = {
      address:        'mail.unibo.it',
      smtp_domain:    'unibo.it',
      enable_starttls_auto: true,
      port:           587,
      user_name:      ENV['UNIBO_SMTP_USERNAME'],
      password:       ENV['UNIBO_SMTP_PASSWORD'],
      authentication: :login
    }
  else
    ActionMailer::Base.smtp_settings = { 
      address: Rails.configuration.dm_unibo_common[:smtp_address], 
      domain:  Rails.configuration.dm_unibo_common[:smtp_domain] 
    }
  end

  ActionMailer::Base.register_interceptor(DmUniboCommon::DevelopmentMailInterceptor) 
  Rails.application.routes.default_url_options[:host] = Rails.configuration.dm_unibo_common[:host]
end
