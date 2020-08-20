class ApplicationController < ActionController::Base
  before_action :force_sso_user
  after_action :verify_authorized, except: [:index, :who_impersonate, :impersonate, :shibboleth]
end
