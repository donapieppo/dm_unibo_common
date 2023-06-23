# frozen_string_literal: true

class DmUniboCommon::PrivacyAlertComponent < ViewComponent::Base
  def initialize(cookies)
    @privacy_cookie_name = (Rails.configuration.session_options[:key] + "_privacy").to_sym
    if ! (@cookie_present = cookies[@privacy_cookie_name])
      cookies[@privacy_cookie_name] = {value: "accepted", expires: 1.year.from_now}
    end
  end

  def render?
    ! @cookie_present
  end
end
