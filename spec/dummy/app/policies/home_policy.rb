class HomePolicy < ApplicationPolicy
  def index?
    true
  end

  def show_if_current_organization?
    current_organization_reader?
  end
end
