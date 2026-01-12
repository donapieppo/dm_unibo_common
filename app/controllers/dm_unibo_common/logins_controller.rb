# based on config/unibo_common.rb :login_method,
# in routes we have
#  get 'auth/entra_id/callback'       to: 'login#entra_id'
#  get 'auth/google_oauth2/callback', to: 'logins#google_oauth2'
#  get 'auth/shibboleth/callback',    to: 'logins#shibboleth'
#  get 'auth/developer/callback',     to: 'logins#developer'
#  get 'auth/test/callback',          to: 'logins#test'
# 
#  get "logins/logout", to: "logins#logout", as: :logout
#  get "logins/no_access", to: "logins#no_access", as: :no_access
#  get "auth/failure", to: "logins#failure"
#
# The application that uses unibo_commmon can define two login_methods:
# login_method: :allow_if_email
#   means that only users already present in database can login
# login_method: :allow_and_create
#   means that any user that passes omniauth authentication can login
#   and is saved in database
#
# and in app/controllers/application_controller.rb can add
# before_filter :force_sso_user
# or
# before_filter :redirect_unsigned_user
#
# force_sso_user means that all the pages are protected
# redirect_unsigned_user means that unsigned user can still see something (to refactor)
#
# see lib/dm_unibo_common/controllers/helpers.rb for method definitions.
module DmUniboCommon
  class LoginsController < ::ApplicationController
    # raise: false see http://api.rubyonrails.org/classes/ActiveSupport/Callbacks/ClassMethods.html#method-i-skip_callback
    skip_before_action :force_sso_user, :redirect_unsigned_user, :check_role, :after_current_user_and_organization, raise: false
    skip_after_action :verify_authorized

    def google_oauth2
      check_provider!(:google_oauth2)
      parse_omniauth
      send login_method
    end

    def entra_id
      check_provider!(:entra_id)
      parse_omniauth
      if check_student_permission
        send login_method
      else
        redirect_to no_access_path and return
      end
    end

    # email="usrBase@testtest.unibo.it" last_name="Base" name="SSO"
    def shibboleth
      check_provider!(:shibboleth)
      parse_omniauth
      if check_student_permission
        send login_method
      else
        redirect_to no_access_path and return
      end
    end

    def developer
      check_provider!(:developer)
      parse_omniauth
      send login_method
    end

    def test
      check_provider!(:test)
      sign_in_and_redirect ::User.find(params[:user_id_id])
    end

    # example ["_shibsession_lauree", "_affcf2ffbe098d5a0928dc72cd9de489"]
    #         ["_lauree_session", "YU5RSTM2OXdYMkRyVjV0SXI1K3c3eDJJdjZQ..... "]
    def logout
      # cookies.delete(Rails.configuration.session_options[:key].to_sym)
      # cookies.delete(shibapplicationid.to_sym)
      session[:user_id] = nil
      cookies.clear
      reset_session
      logger.info("after logout we redirect to params[:return] = #{params[:return]}")
      case omniauth_provider
      when :entra_id
        redirect_to "https://login.microsoftonline.com/common/oauth2/v2.0/logout?post_logout_redirect_uri=#{main_app.root_url}", allow_other_host: true
      when :developer
        redirect_to main_app.home_path
      when :shibboleth
        redirect_to Rails.configuration.unibo_common.logout_link, allow_other_host: true
      when :google_oauth2
        redirect_to "https://www.google.com/accounts/Logout?continue=#{main_app.root_url}", allow_other_host: true
      end
    end

    # Not authorized but valid credentials
    def no_access
      render layout: nil
    end

    def failure
      Rails.logger.info("dm_unibo_common.login failure")
    end

    private

    def omniauth_provider
      Rails.configuration.unibo_common.omniauth_provider
    end

    # check the provider in unibo_common config
    # for developer or test check only local connections
    def check_provider!(provider)
      omniauth_provider == provider or raise DmUniboCommon::WrongOauthMethod
      if provider == :test || provider == :developer
        if !(request.remote_ip == "127.0.0.1" ||
             request.remote_ip == "::1" ||
             request.remote_ip =~ /^172\.\d+\.\d+\.\d+/)
          raise "ONLY LOCAL OR DOCKER IPS. YOU ARE #{request.remote_ip}"
        end
      end
      true
    end

    def check_student_permission
      if Rails.configuration.unibo_common.no_students && @email && @email !~ /@unibo.it$/
        Rails.logger.info "dm_unibo_common.login: #{@email} not allowed as students are not allowed."
        false
      else
        true
      end
    end

    # the default is conservative where you log only if user in database
    def login_method
      if @email.blank? && @upn.blank? && @id_anagrafica_unica.to_i < 1
        render action: :failure
        return
      else
        Rails.configuration.unibo_common.login_method || "allow_if_email"
      end
    end

    def debug_message(msg)
      if Rails.configuration.unibo_common.login_debug
        Rails.logger.info("dm_unibo_common.login debug: #{msg}")
      end
    end

    def parse_omniauth
      debug_message(request.env["omniauth.auth"].inspect)
      user_info = request.env["omniauth.auth"]
      @email = user_info.info.email
      @upn = @email # can be updated for microsoft logins
      @name = user_info.info.first_name
      @surname = user_info.info.last_name

      case omniauth_provider
      when :entra_id
        if request.env["omniauth.auth"]["extra"]["raw_info"]
          @upn = user_info.extra.raw_info.upn
          @id_anagrafica_unica = user_info.extra.raw_info.idAnagraficaUnica.to_i
        end
      when :shibboleth
        @upn = user_info.uid
      when :developer
        @upn = @email = params[:upn]
        @name = params[:name]
        @surname = params[:surname]
        last_user = ::User.where("id < 3000").order("id desc").first
        @developer_id_anagrafica_unica = last_user ? last_user.id + 1 : 0
      end
    end

    # def parse_shibboleth
    #   @upn = request.env["omniauth.auth"].uid
    #   oinfo = request.env["omniauth.auth"].info
    #   extra = request.env["omniauth.auth"].extra.raw_info
    #
    #   @id_anagrafica_unica = extra.idAnagraficaUnica.to_i
    #   @id_anagrafica_unica > 0 or raise "NO idAnagraficaUnica"
    #
    #   @is_member_of = extra.isMemberOf ? extra.isMemberOf.split(";") : []
    #   set_memberof_session(@is_member_of)
    #
    #   @email = @upn
    #   @name = oinfo.first_name || oinfo.name
    #   @surname = oinfo.last_name
    #   @nationalpin = extra.codiceFiscale
    # end

    # def set_memberof_session(is_member_of)
    #   (Rails.env.development? and is_member_of << "user") unless is_member_of.include?("user")
    #   session[:is_member_of] = is_member_of
    # end

    def get_existing_user
      if @id_anagrafica_unica.to_i > 0
        ::User.find_by_id(@id_anagrafica_unica)
      elsif omniauth_provider == :google_oauth2
        ::User.find_by_email(@email)
      else
        ::User.find_by_upn(@upn)
      end
    end

    def allow_and_create
      Rails.logger.info("dm_unibo_common.login: allow_and_create: @email=#{@email} - @id_anagrafica_unica=#{@id_anagrafica_unica} - @upn=#{@upn}")
      user = get_existing_user
      if user
        update_missing_user_data(user)
      else
        new_user_id = @id_anagrafica_unica || @developer_id_anagrafica_unica || nil
        logger.info "Authentication: User #{@email} to be CREATED"
        h = {
          id: new_user_id,
          upn: @upn,
          email: @email,
          name: @name,
          surname: @surname
        }
        # h[:nationalpin] = @nationalpin if ::User.column_names.include?("nationalpin")
        user = ::User.create!(h)
      end
      logger.info "dm_unibo_common.login: allow_and_create: user: #{user.inspect}"
      sign_in_and_redirect user
    end
    alias_method :log_and_create, :allow_and_create # old syntax

    def allow_if_email
      Rails.logger.info("dm_unibo_common.login: allow_if_email: @email=#{@email} - @id_anagrafica_unica=#{@id_anagrafica_unica} @upn=#{@upn}")
      user = get_existing_user
      if user
        logger.info "dm_unibo_common.login: allow_if_email: user: #{user.inspect}"
        update_missing_user_data(user)
        sign_in_and_redirect user
      else
        logger.info "dm_unibo_common.login: allow_if_email: upn:#{@upn} - id_anagrafica_unica: #{@id_anagrafica_unica} not allowed"
        redirect_to no_access_path
      end
    end
    alias_method :log_if_email, :allow_if_email # old syntax

    def sign_in_and_redirect(user)
      original_request = session[:original_unlogged_request]
      logger.info("dm_unibo_common.login: sign_in_and_redirect with original_unlogged_request=#{original_request}")

      reset_session
      session[:user_id] = user.id
      session[:original_unlogged_request] = original_request if original_request
      redirect_to original_request || main_app.root_path
    end

    def update_missing_user_data(user)
      if user&.name.blank? && @name.present?
        logger.info "dm_unibo_common.login: updated user name, surname, email"
        user.update(name: @name, surname: @surname, email: @email)
      end
    end
  end
end
