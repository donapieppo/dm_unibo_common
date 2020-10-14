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

  def update?
    @user && @user.is_cesia?
  end

  def self.configure_authlevels(h)
    h.each do |name, number|
      define_method :"#{name}?" do 
        @user && @user.authorization.send("can_#{name}?", @record)
      end

      define_method :"only_#{name}?" do 
        @user && @user.authorization.send("can_only_#{name}?", @record)
      end
    end
  end
end
