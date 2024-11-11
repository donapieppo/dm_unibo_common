# frozen_string_literal: true

class DmUniboCommon::HeaderComponent < ViewComponent::Base
  def initialize
    @title = Rails.configuration.unibo_common.html_title
    @description = Rails.configuration.unibo_common.html_description
  end
end
