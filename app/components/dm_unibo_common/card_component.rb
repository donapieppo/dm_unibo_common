# frozen_string_literal: true

class DmUniboCommon::CardComponent < ViewComponent::Base
  include DmUniboCommon::ApplicationHelper

  def initialize(title: "", icon: nil, css_class: "", help: nil)
    @title = title
    @icon = icon
    @css_class = css_class
    @help = help
  end
end
