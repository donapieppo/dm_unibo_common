module DmUniboCommon
  class ApplicationController < ActionController::Base
    protect_from_forgery with: :exception
    include Pundit::Authorization

    include DmUniboCommon::Controllers::Helpers

    # impersonates :user, method: :current_user, with: ->(id) { DmUniboCommon::CurrentUser.find(id) }
    impersonates :user, method: :current_user, with: ->(id) { ::User.find(id) }

    def default_url_options(_options = {})
      _options[:__org__] = current_organization ? current_organization.code : nil
      _options
    end

    def after_current_user_and_organization
    end
  end
end
