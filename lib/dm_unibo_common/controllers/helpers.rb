module DmUniboCommon
  module Controllers
    module Helpers
      # extend ActiveSupport::Concern
      # helper :user_owns?, :user_owns!, :user_admin?, :user_admin!, :user_cesia?, :user_cesia!

      # ActiveSupport.on_load(:action_controller) do
      #   helper_method :current_user, 
      #                 :user_signed_in?, 
      #                 :user_owns?,  :user_owns!, 
      #                 :user_admin?, :user_admin!, 
      #                 :user_cesia?, :user_cesia!
      # end

      def self.included(base)
        base.extend Helpers
        base.helper_method :current_user, 
          :user_signed_in?, 
          :user_owns?,  :user_owns!, 
          :user_admin?, :user_admin!, 
          :user_cesia?, :user_cesia!
      end

      def current_user
        # return @current_user if @current_user
        # session[:user_id].to_i > 0 or return nil
        # @current_user = ::User.find(session[:user_id])
        (@current_user ||= ::User.find(session[:user_id])) if session[:user_id]
      end

      def user_signed_in?
        current_user
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
        if ! current_user
          session[:original_request] = request.fullpath

          if Rails.configuration.dm_unibo_common[:omniauth_provider] == :google_oauth2
            redirect_to auth_google_oauth2_callback_path and return 
          elsif Rails.configuration.dm_unibo_common[:omniauth_provider] == :shibboleth
            redirect_to auth_shibboleth_callback_path and return 
          # developer solo in localhost
          elsif Rails.configuration.dm_unibo_common[:omniauth_provider] == :developer 
            redirect_to auth_developer_callback_path and return
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

