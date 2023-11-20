# frozen_string_literal: true

DM_UNIBO_COMMON_PRIVACY_KEY = (Rails.configuration.session_options[:key] + "_privacy").to_sym

class DmUniboCommon::PrivacyAlertComponent < ViewComponent::Base
  def initialize(cookies)
    @privacy_accepted = cookies[DM_UNIBO_COMMON_PRIVACY_KEY]
    if !@privacy_accepted
      cookies[DM_UNIBO_COMMON_PRIVACY_KEY] = {value: "accepted", expires: 1.year.from_now}
    end
  end

  private

  def render?
    !@privacy_accepted
  end
end
