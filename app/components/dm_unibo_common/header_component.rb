# frozen_string_literal: true

class DmUniboCommon::HeaderComponent < ViewComponent::Base
  def initialize
    @title = Rails.configuration.html_title
    @description = Rails.configuration.html_description
  end
end
