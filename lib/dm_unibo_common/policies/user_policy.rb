module DmUniboCommon
class UserPolicy < ApplicationPolicy
  def index?
    @user.is_cesia?
  end

  # only superuser
  def create?
    @user.is_cesia?
  end

  # only superuser
  def update?
    create?
  end

  def destroy?
    update?
  end
end
end

