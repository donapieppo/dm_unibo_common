module DmUniboCommon
  module Controllers
    module Helpers
      extend ActiveSupport::Concern

      included do
        if respond_to?(:helper_method)
          helper_method :modal_page,
            :set_current_user, :current_user,
            :set_current_organization, :current_organization,
            :update_authorization,
            :user_signed_in?,
            :current_user_owns?, :current_user_owns!,
            :current_user_admin?, :current_user_admin!,
            :current_user_cesia?, :current_user_user_cesia!,
            :current_user_has_some_authorization?,
            :current_user_possible_organizations
        end
      end

      def modal_page
        request.headers.fetch("HTTP_TURBO_FRAME", "") == "modal"
      end

      def set_current_user
        if request.session[:user_id]
          @_current_user = ::User.find(request.session[:user_id])
        end
      end

      # to separate from set_current_user because of impersonation (Pretender gem)
      def update_authorization
        current_user&.extend(DmUniboCommon::CurrentUser) && current_user.update_authorization_by_ip(request.remote_ip)
      end

      def current_user
        @_current_user
      end

      def user_signed_in?
        !!current_user
      end

      def log_current_user
        current_user or return true
        if current_user != true_user
          logger.info("#{true_user.upn} IMPERSONATING #{current_user.upn} on #{current_organization&.code}")
        else
          logger.info("Current user: #{current_user.upn} on #{current_organization&.code}")
        end
      end

      # see Rails.configuration.unibo_common.omniauth_provider
      # actually: shibboleth (for unibo) and google_oauth2
      # Use in app/controllers/application_controller.rb like
      # before_filter :log_current_user, :force_sso_user
      def force_sso_user
        if !current_user
          logger.info("force_sso_user: no current_user")
          session[:original_unlogged_request] = request.fullpath
          if Rails.configuration.unibo_common.omniauth_provider == :shibboleth
            redirect_to dm_unibo_common.auth_shibboleth_callback_path and return
          else
            redirect_to main_app.home_path and return
          end
        end
      end

      def redirect_unsigned_user
        if !user_signed_in?
          redirect_to main_app.home_path, alert: "Si prega di loggarsi per accedere alla pagina richiesta."
        end
      end

      def shibapplicationid
        "_shibsession_" + ENV["Shib-Application-ID"].to_s
      end

      # no security hidden.
      # ?__org__=mat
      # /mat/seminars
      # if not params[:__org__] consider the first possible organization of current_user
      # Remember: without current user we may be in shibboleth redirect
      def set_current_organization
        if params.has_key?(:__org__)
          @_current_organization = ::Organization.find_by_code(params[:__org__])
        elsif current_user&.single_organization?
          @_current_organization = current_user.my_organizations.first
          logger.info("set_current_organization as the only for current_user")
        end

        if current_user && @_current_organization
          current_user.current_organization = @_current_organization
        end
      end

      def current_organization
        @_current_organization
      end

      # PERMISSIONS (FIXME: TODO: Move all to dm_unibo_common/app/models/dm_unibo_common/current_user)
      def current_user_has_some_authorization?
        current_user&.has_some_authorization?
      end

      def current_user_possible_organizations
        current_user ? current_user.my_organizations : []
      end

      def current_user_owns?(what)
        current_user&.owns?(what)
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
        current_user&.is_cesia?
      end

      def current_user_cesia!
        user_cesia? or raise DmUniboCommon::NoAccess
      end
    end
  end
end
