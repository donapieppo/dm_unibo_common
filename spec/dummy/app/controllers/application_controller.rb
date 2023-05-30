class ApplicationController < DmUniboCommon::ApplicationController
  before_action :set_current_user, :update_authorization, :set_current_organization, :log_current_user, :redirect_unsigned_user
  after_action :verify_authorized, except: [:who_impersonate, :impersonate, :stop_impersonating]
end
