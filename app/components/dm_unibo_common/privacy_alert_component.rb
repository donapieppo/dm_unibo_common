# frozen_string_literal: true

class DmUniboCommon::PrivacyAlertComponent < ViewComponent::Base
  def initialize(cookies)
    dm_unibo_common_privacy_key = (Rails.configuration.session_options[:key] + "_privacy").to_sym

    if !(@privacy_accepted = cookies[dm_unibo_common_privacy_key])
      cookies[dm_unibo_common_privacy_key] = {value: "accepted", expires: 1.year.from_now}
    end
  end

  private

  def render?
    !@privacy_accepted
  end
end
