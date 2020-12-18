module DmUniboCommon
class ImpersonationPolicy < ApplicationPolicy
  def impersonate?
  end

  def stop_impersonating?
    true
  end
end
end

