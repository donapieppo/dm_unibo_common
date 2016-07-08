module DmUniboCommon
  module Controllers
    module Helpers
      # extend ActiveSupport::Concern
      # helper :user_owns?, :user_owns!, :user_admin?, :user_admin!, :user_cesia?, :user_cesia!

      ActiveSupport.on_load(:action_controller) do
        helper_method :user_owns?, :user_owns!, :user_admin?, :user_admin!, :user_cesia?, :user_cesia!
      end

      def log_current_user
        current_user or return true
        if current_user != true_user
          logger.info("#{true_user.upn} IMPERSONATING #{current_user.upn}")
        else
          logger.info("Current user: #{current_user.upn}")
        end
      end

      # see Rails.configuration.dm_unibo_common[:omniauth_provider]
      # actually: shibboleth (for unibo) and google_oauth2
      # Use in app/controllers/application_controller.rb like
      # before_filter :log_current_user, :force_sso_user
      def force_sso_user
        if ! user_signed_in?
          session[:original_request] = request.fullpath

          # user_omniauth_authorize_path(Rails.configuration.dm_unibo_common[:omniauth_provider])
          # used to work. No more?
          if Rails.configuration.dm_unibo_common[:omniauth_provider] == 'google_oauth2'
            redirect_to user_google_oauth2_omniauth_authorize_path and return 
          elsif Rails.configuration.dm_unibo_common[:omniauth_provider] == 'shibboleth'
            redirect_to user_shibboleth_omniauth_authorize_path and return 
          else
            raise "problem in omniauth provider"
          end
          # redirect_to user_google_oauth2_omniauth_authorize_path and return 
          # redirect_to new_user_session_path and return
        end
      end

      def redirect_unsigned_user
        if ! user_signed_in?
          redirect_to root_path, alert: "Si prega di loggarsi per accedere alla pagina richiesta."
          return
        end
      end

      # example ["_shibsession_lauree", "_affcf2ffbe098d5a0928dc72cd9de489"]
      #         ["_lauree_session", "YU5RSTM2OXdYMkRyVjV0SXI1K3c3eDJJdjZQ..... "]
      def after_sign_out_path_for(resource_or_scope)
        cookies.delete(Rails.configuration.session_options[:key].to_sym)
        cookies.delete(shibapplicationid.to_sym)
        logger.info("after_sign_out_path_for: redirect to params[:return] = #{params[:return]}")
        params[:return] || 'http://www.unibo.it'
      end

      # https://github.com/plataformatec/devise/wiki/How-To:-redirect-to-a-specific-page-on-successful-sign-in
      # for session session[:original_request] see for example in seminars app/controllers/application_controller.rb
      # where session[:original_request] = request.fullpath before a redirect to authentication
      def after_sign_in_path_for(resource)
        session[:original_request] || root_path
        # no request.env['omniauth.origin']  
      end

      def shibapplicationid
        "_shibsession_" + ENV['Shib-Application-ID'].to_s
      end 

      #
      # PERMISSIONS
      #

      def user_owns?(what)
        current_user and current_user.owns?(what)
      end

      def user_owns!(what)
        user_owns?(what) or raise DmUniboCommon::NoAccess
      end

      def user_admin?
        current_user and current_user.is_admin? 
      end

      def user_admin!
        user_admin? or raise DmUniboCommon::NoAccess
      end

      def user_cesia?
        current_user and current_user.is_cesia? 
      end

      def user_cesia!
        user_cesia? or raise DmUniboCommon::NoAccess
      end
    end
  end
end

