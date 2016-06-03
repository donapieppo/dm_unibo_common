class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  # https://github.com/plataformatec/devise/issues/2432
  skip_before_filter :verify_authenticity_token, :force_sso_user, :check_role, :retrive_authlevel, :user_logged_not_raise!

  # env["omniauth.auth"].provider == google_oauth2
  # env['omniauth.auth'].info = {email, name, last_name}
  def google_oauth2
    login_method = Rails.configuration.dm_unibo_common[:login_method] || "log_if_email"
    parse_google_omniauth
    send login_method
  end

  # email="usrBase@testtest.unibo.it" last_name="Base" name="SSO"
  def shibboleth
    login_method = Rails.configuration.dm_unibo_common[:login_method] || "log_if_email"
    log_unibo_omniauth
    parse_unibo_omniauth
    send login_method
  end

  private 

  def parse_google_omniauth
    oinfo = env['omniauth.auth'].info
    @email   = oinfo.email
    @name    = oinfo.name
    @surname = oinfo.last_name
  end

  def parse_unibo_omniauth
    oinfo = env['omniauth.auth'].info
    extra = env['omniauth.auth'].extra.raw_info

    @idAnagraficaUnica = extra.idAnagraficaUnica.to_i
    @idAnagraficaUnica > 0 or raise "NO idAnagraficaUnica"

    @isMemberOf = extra.isMemberOf ? extra.isMemberOf.split(';') : []
    set_memberof_session(@isMemberOf)

    @email         = oinfo.email
    @name          = oinfo.first_name || oinfo.name
    @surname       = oinfo.last_name
    @nationalpin   = extra.codiceFiscale

    if Rails.configuration.dm_unibo_common[:no_students] and @email !~ /@unibo.it$/
      logger.info "Students are not allowed"
      redirect_to no_access_path and return
    end
  end

  def set_memberof_session(isMemberOf)
    (Rails.env.development? and isMemberOf << 'user') unless isMemberOf.include?('user')
    session[:isMemberOf] = isMemberOf
  end

  def log_and_create
    user = @idAnagraficaUnica ? User.where(id: @idAnagraficaUnica).first : User.where(email: @email).first
    if ! user
      logger.info "Authentication: User #{@email} to be CREATED"
      h = {id:      @idAnagraficaUnica || 0,
           upn:     @email,
           email:   @email,
           name:    @name, 
           surname: @surname }
      h[:nationalpin] = @nationalpin if User.column_names.include?('nationalpin')
      user = User.create!(h)
    end
    logger.info "Authentication: log_and_create as #{user.inspect} with groups #{session[:isMemberOf].inspect}"
    sign_in_and_redirect user, event: :authentication    
  end

  def log_if_email
    user = @idAnagraficaUnica ? User.where(id: @idAnagraficaUnica).first : User.where(email: @email).first
    if user
      logger.info "Authentication: log_if_email as #{user.inspect} with groups #{session[:isMemberOf].inspect}"
      user.update_attributes(name: @name, surname: @surname)
      sign_in_and_redirect user, event: :authentication    
    else
      logger.info "User #{@email} not allowed"
      redirect_to no_access_path
    end
  end

  def log_unibo_omniauth
    env['omniauth.auth'] or return
    logger.info("Authentication: uid   = #{env['omniauth.auth'].uid}")
    logger.info("Authentication: info  = #{env['omniauth.auth'].info}")
    logger.info("Authentication: extra = #{env['omniauth.auth'].extra}")
  end
end
