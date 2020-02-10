module DmUniboCommon
class OrganizationPolicy 
  def index?
    @user && @user.cesia?
  end

  def show?
    @user && @user.cesia?
  end

  def read?
    @user && @user.authorization.can_read?(@record)
  end

  def manage?
    @user && @user.authorization.can_manage?(@record)
  end
end
end
