module DmUniboCommon
  module Controllers
    module Helpers
      # extend ActiveSupport::Concern
      # helper :user_owns?, :user_owns!, :user_admin?, :user_admin!, :user_cesia?, :user_cesia!

      # helper_method in AbstractController::Helpers::ClassMethods
      # Declare a controller method as a helper. 
      # ActiveSupport.on_load(:action_controller) do
      #   if respond_to?(:helper_method)
      #     helper_method :current_user, 
      #                   :user_signed_in?, 
      #                   :user_owns?,  :user_owns!, 
      #                   :user_admin?, :user_admin!, 
      #                   :user_cesia?, :user_cesia!
      #   end
      # end

      def self.included(base)
        base.extend Helpers
        if base.respond_to? :helper_method
          base.helper_method :modal_page, 
                             :current_user, :user_signed_in?, :current_organization,  
                             :current_user_owns?,  :current_user_owns!, 
                             :current_user_admin?, :current_user_admin!, 
                             :current_user_cesia?, :current_user_user_cesia!
        end
      end

      def modal_page
        params[:modal] && params[:modal] == 'yyy'
      end

      def current_user
        (@current_user ||= ::User.find(session[:user_id])) if session[:user_id]
      end

      def user_signed_in?
        !!current_user
      end

      def current_organization
        @_current_organization
      end

      # FIXME da pensare
      def set_current_user(user)
        logger.info("Setting current_user=#{user.email}")
        @current_user = user
        session[:user_id] = user.id
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
            redirect_to dm_unibo_common.auth_google_oauth2_callback_path and return 
          elsif Rails.configuration.dm_unibo_common[:omniauth_provider] == :shibboleth
            redirect_to dm_unibo_common.auth_shibboleth_callback_path and return 
          elsif Rails.configuration.dm_unibo_common[:omniauth_provider] == :developer 
            redirect_to dm_unibo_common.auth_developer_callback_path and return
          else
            raise "problem in omniauth provider (not in :google_oauth2, :shibboleth, :developer)"
          end
          # redirect_to user_google_oauth2_omniauth_authorize_path and return 
          # redirect_to new_user_session_path and return
        end
      end

      def redirect_unsigned_user
        if ! user_signed_in?
          redirect_to main_app.root_path, alert: "Si prega di loggarsi per accedere alla pagina richiesta."
          return
        end
      end

      def shibapplicationid
        "_shibsession_" + ENV['Shib-Application-ID'].to_s
      end 

      def update_current_user_authlevels
        current_user.update_authorization_by_ip(request.remote_ip) if current_user
      end

      # no security hidden. 
      # ?__org__=mat
      # or /mat/seminars
      def set_organization
        if params[:__org__]
          @_current_organization = ::Organization.find_by_code(params[:__org__])
        elsif current_user
          @_current_organization = current_user.authorization.organizations.first if current_user.has_some_authorization?
        end
      end


      #
      # PERMISSIONS
      #

      def current_user_owns?(what)
        current_user && current_user.owns?(what)
      end

      def current_user_owns!(what)
        current_user_owns?(what) or raise DmUniboCommon::NoAccess
      end

      def current_user_admin?
        current_user && current_organization && current_user.authorization.can_manage?(current_organization)
      end

      def current_user_admin!
        current_user_admin? or raise DmUniboCommon::NoAccess
      end

      def current_user_cesia?
        current_user and current_user.is_cesia? 
      end

      def current_user_cesia!
        user_cesia? or raise DmUniboCommon::NoAccess
      end
    end
  end
end

