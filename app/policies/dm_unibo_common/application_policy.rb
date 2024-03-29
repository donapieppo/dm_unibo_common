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

    def organization_reader?(o)
      @user && ::OrganizationPolicy.new(@user, o).read?
    end

    def organization_manager?(o)
      @user && ::OrganizationPolicy.new(@user, o).manage?
    end

    def current_organization_reader?
      organization_reader?(@user.current_organization)
    end

    def current_organization_manager?
      organization_manager?(@user.current_organization)
    end

    def record_organization_manager?
      @user && ::OrganizationPolicy.new(@user, @record.organization_id).manage?
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
