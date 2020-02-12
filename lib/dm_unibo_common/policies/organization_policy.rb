module DmUniboCommon
class OrganizationPolicy 
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

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
