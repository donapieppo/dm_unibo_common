module DmUniboCommon
  class ApplicationController < ActionController::Base
    protect_from_forgery with: :exception
    include Pundit

    include DmUniboCommon::Controllers::Helpers

    impersonates :user, method: :current_user, with: ->(id) { DmUniboCommon::CurrentUser.find(id) }

    before_action :set_current_user, :set_current_organization, :update_authorization, :log_current_user

    def default_url_options(_options={})
      _options[:__org__] = current_organization ? current_organization.code : nil
      _options
    end
  end
end
