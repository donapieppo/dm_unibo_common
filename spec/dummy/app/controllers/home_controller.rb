class HomeController < ApplicationController
  skip_before_action :force_sso_user, :after_current_user_and_organization, raise: false

  def index
    authorize :home
  end

  def show_if_current_organization
    authorize :home
  end
end
