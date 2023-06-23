class HomeController < ApplicationController
  def index
    authorize :home
  end

  def show_if_current_organization
    authorize :home
  end
end
