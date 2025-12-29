# frozen_string_literal: true

class DmUniboCommon::ImpersonationComponent < ViewComponent::Base
  include DmUniboCommon::ApplicationHelper

  def initialize(current_user, true_user, who_impersonate_path: "", stop_impersonating_path: "")
    @current_user = current_user
    @true_user = true_user
    @who_impersonate_path = who_impersonate_path
    @stop_impersonating_path = stop_impersonating_path
    @can_impersonate = @true_user && Rails.configuration.unibo_common.impersonate_admins&.include?(@true_user.upn)
  end

  def render?
    @can_impersonate
  end
end
