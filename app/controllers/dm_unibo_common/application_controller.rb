module DmUniboCommon
  class ApplicationController < ActionController::Base
    protect_from_forgery with: :exception

    include Pundit::Authorization
    include DmUniboCommon::Controllers::Helpers

    after_action :verify_authorized

    # impersonates :user, method: :current_user, with: ->(id) { DmUniboCommon::CurrentUser.find(id) }
    impersonates :user, method: :current_user, with: ->(id) { ::User.find(id) }

    def default_url_options(o = {})
      o[:__org__] = current_organization ? current_organization.code : nil
      o
    end

    def after_current_user_and_organization
    end
  end
end
