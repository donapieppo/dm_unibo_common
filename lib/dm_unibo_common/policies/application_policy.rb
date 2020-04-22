module DmUniboCommon
class ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def owner?
    @user && @record.user_id == @user.id
  end

  def record_organization_manager?
    @user && @user.authorization.can_manage?(@record.organization_id)
  end

  def owner_or_record_organization_manager?
    record_organization_manager? || owner?
  end

  def index?
    false
  end

  def show?
    false
  end

  def create?
    false
  end

  def new?
    create?
  end

  def update?
    false
  end

  def edit?
    update?
  end

  def destroy?
    false
  end

  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      scope.all
    end
  end
end
end
