Rails.application.reloader.to_prepare do
  ActionMailer::Base.smtp_settings = if Rails.configuration.unibo_common.smtp_unibo
    {
      address: "mail.unibo.it",
      smtp_domain: "unibo.it",
      enable_starttls_auto: true,
      port: 587,
      user_name: ENV["SMTP_USERNAME"],
      password: ENV["SMTP_PASSWORD"],
      authentication: :login
    }
  else
    {
      address: Rails.configuration.unibo_common.smtp_address,
      domain: Rails.configuration.unibo_common.smtp_domain
    }
  end

  ActionMailer::Base.register_interceptor(DmUniboCommon::DevelopmentMailInterceptor)
  Rails.application.routes.default_url_options[:host] = Rails.configuration.unibo_common.host
end
