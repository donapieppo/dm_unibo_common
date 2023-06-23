# frozen_string_literal: true

class DmUniboCommon::ImpersonationComponent < ViewComponent::Base
  def initialize(current_user, true_user)
    @current_user = current_user
    @true_user = true_user
    @can_impersonate = @true_user && Rails.configuration.dm_unibo_common[:impersonate_admins] && Rails.configuration.dm_unibo_common[:impersonate_admins].include?(@true_user.upn)
  end

  def render?
    @can_impersonate
  end
end
