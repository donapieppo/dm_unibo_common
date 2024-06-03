# Take a look at http://railscasts.com/episodes/241-simple-omniauth
# The main difference is that we mainly use shibboleth authentication.
#
# in routes we have
#   get 'auth/google_oauth2/callback', to: 'logins#google_oauth2'
#   get 'auth/shibboleth/callback',    to: 'logins#shibboleth'
#   get 'auth/developer/callback',     to: 'logins#developer'
#   get 'auth/test/callback',          to: 'logins#test'
#   get 'auth/azure_activedirectory_v2/callback' to: 'login#azure'
#
# The application that uses dm_unibo_commmon can define two login_methods:
# login_method: :allow_if_email
#   means that only users already present in database can login
# login_method: :allow_and_create
#   means that any user that passes omniauth authentication can login
#   and is saved in database
#
# and in app/controllers/application_controller.rb can add
# before_filter :log_current_user, :force_sso_user
# or
# before_filter :log_current_user, :redirect_unsigned_user
#
# force_sso_user means that all the pages are protected
# redirect_unsigned_user means that unsigned user can still see something (to refactor)
#
# see lib/dm_unibo_common/controllers/helpers.rb for method definitions.
module DmUniboCommon
  class LoginsController < ::ApplicationController
    # raise: false see http://api.rubyonrails.org/classes/ActiveSupport/Callbacks/ClassMethods.html#method-i-skip_callback
    skip_before_action :force_sso_user, :redirect_unsigned_user, :check_role, :after_current_user_and_organization, raise: false

    # env['omniauth.auth'].info = {email, name, last_name}
    def google_oauth2
      Rails.configuration.dm_unibo_common[:omniauth_provider] == :google_oauth2 or raise DmUniboCommon::WrongOauthMethod
      skip_authorization
      parse_google_omniauth
      send login_method
    end

    def azure_activedirectory_v2
      Rails.configuration.dm_unibo_common[:omniauth_provider] == :azure_activedirectory_v2 or raise DmUniboCommon::WrongOauthMethod
      skip_authorization
      parse_azure_omniauth
      send login_method
    end

    # email="usrBase@testtest.unibo.it" last_name="Base" name="SSO"
    def shibboleth
      Rails.configuration.dm_unibo_common[:omniauth_provider] == :shibboleth or raise DmUniboCommon::WrongOauthMethod
      skip_authorization
      log_unibo_omniauth
      parse_unibo_omniauth

      if Rails.configuration.dm_unibo_common[:no_students] && @email !~ /@unibo.it$/
        logger.info "Students are not allowed: #{@email} user not allowed."
        redirect_to no_access_path and return
      else
        send login_method
      end
    end

    def developer
      Rails.configuration.dm_unibo_common[:omniauth_provider] == :developer or raise DmUniboCommon::WrongOauthMethod
      skip_authorization
      if request.remote_ip == "127.0.0.1" || request.remote_ip == "::1" || request.remote_ip =~ /^172\.\d+\.\d+\.\d+/
        sign_in_and_redirect ::User.find_by_upn(params[:upn])
      else
        raise "ONLY LOCAL OR DOCKER IPS. YOU ARE #{request.remote_ip}"
      end
    end

    def test
      Rails.configuration.dm_unibo_common[:omniauth_provider] == :test or raise
      skip_authorization
      if request.remote_ip == "127.0.0.1" || request.remote_ip == "::1" || request.remote_ip =~ /^172\.\d+\.\d+\.\d+/
        user = ::User.find(params[:user_id_id])
        Rails.logger.info("#{params[:user_id_id]} -> #{user.inspect}")
        sign_in_and_redirect ::User.find(params[:user_id_id])
      else
        raise "ONLY LOCAL OF DOCKER. YOU ARE #{request.remote_ip}"
      end
    end

    # example ["_shibsession_lauree", "_affcf2ffbe098d5a0928dc72cd9de489"]
    #         ["_lauree_session", "YU5RSTM2OXdYMkRyVjV0SXI1K3c3eDJJdjZQ..... "]
    def logout
      skip_authorization
      # cookies.delete(Rails.configuration.session_options[:key].to_sym)
      # cookies.delete(shibapplicationid.to_sym)
      session[:user_id] = nil
      cookies.clear
      reset_session
      logger.info("after logout we redirect to params[:return] = #{params[:return]}")
      if Rails.configuration.dm_unibo_common[:omniauth_provider] == :azure_activedirectory_v2
        redirect_to home_path and return
      end
      redirect_to Rails.configuration.dm_unibo_common[:logout_link], allow_other_host: true
      # redirect_to (params[:return] || 'http://www.unibo.it')
    end

    # Not authorized but valid credentials
    def no_access
      skip_authorization
      render layout: nil
    end

    def pippo_show
      skip_authorization
      # raise env.inspect
    end

    private

    # the default is conservative where you log only if user in database
    def login_method
      Rails.configuration.dm_unibo_common[:login_method] || "allow_if_email"
    end

    def parse_azure_omniauth
      if (oa = request.env["omniauth.auth"]["extra"]["raw_info"])
        @email = oa.email
        @name = oa.first_name
        @surname = oa.last_name
        @id_anagrafica_unica = oa.idAnagraficaUnica.to_i
      end
    end

    def parse_google_omniauth
      oinfo = request.env["omniauth.auth"].info
      @email = oinfo.email
      @name = oinfo.name
      @surname = oinfo.last_name
    end

    def parse_unibo_omniauth
      @upn = request.env["omniauth.auth"].uid
      oinfo = request.env["omniauth.auth"].info
      extra = request.env["omniauth.auth"].extra.raw_info

      @id_anagrafica_unica = extra.idAnagraficaUnica.to_i
      @id_anagrafica_unica > 0 or raise "NO idAnagraficaUnica"

      @is_member_of = extra.isMemberOf ? extra.isMemberOf.split(";") : []
      set_memberof_session(@is_member_of)

      @email = @upn
      @name = oinfo.first_name || oinfo.name
      @surname = oinfo.last_name
      @nationalpin = extra.codiceFiscale
    end

    def set_memberof_session(is_member_of)
      (Rails.env.development? and is_member_of << "user") unless is_member_of.include?("user")
      session[:is_member_of] = is_member_of
    end

    def allow_and_create
      user = @id_anagrafica_unica ? ::User.where(id: @id_anagrafica_unica).first : ::User.where(email: @email).first
      if !user
        logger.info "Authentication: User #{@email} to be CREATED"
        h = {
          id: @id_anagrafica_unica || 0,
          upn: @email,
          email: @email,
          name: @name,
          surname: @surname
        }
        h[:nationalpin] = @nationalpin if ::User.column_names.include?("nationalpin")
        user = ::User.create!(h)
      end
      logger.info "Authentication: allow_and_create as #{user.inspect} with groups #{session[:is_member_of].inspect}"
      sign_in_and_redirect user
    end
    alias_method :log_and_create, :allow_and_create # old syntax

    def allow_if_email
      Rails.logger.info("Authentication: allow_if_email with @email = #{@email} @id_anagrafica_unica = #{@id_anagrafica_unica}")
      user = @id_anagrafica_unica ? ::User.where(id: @id_anagrafica_unica).first : ::User.where(email: @email).first
      if user
        logger.info "Authentication: allow_if_email as #{user.inspect} with groups #{session[:is_member_of].inspect}"
        user.update(name: @name, surname: @surname)
        sign_in_and_redirect user
      else
        logger.info "User #{@email} not allowed"
        redirect_to no_access_path
      end
    end
    alias_method :log_if_email, :allow_if_email # old syntax

    def log_unibo_omniauth
      request.env["omniauth.auth"] or return
      logger.info("Authentication: uid  = #{request.env["omniauth.auth"].uid}")
      logger.info("Authentication: info = #{request.env["omniauth.auth"].info}")
      logger.info("Authentication: extra = #{request.env["omniauth.auth"].extra}")
    end

    def sign_in_and_redirect(user)
      session[:user_id] = user.id
      redirect_to session[:original_request] || main_app.root_path
    end
  end
end
