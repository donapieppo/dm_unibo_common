class DmUniboCommon::OrganizationPolicy < DmUniboCommon::ApplicationPolicy
  def index?
    @user && @user.is_cesia?
  end

  def show?
    @user && @user.is_cesia?
  end

  def create?
    @user && @user.is_cesia?
  end

  def read?
    @user && @user.authorization.can_read?(@record)
  end

  def manage?
    @user && @user.authorization.can_manage?(@record)
  end
end
