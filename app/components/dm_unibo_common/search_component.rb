# frozen_string_literal: true

class DmUniboCommon::SearchComponent < ViewComponent::Base
  def initialize(search_path: nil, placeholder: "", title: "", type: "string")
    @search_path = search_path
    @placeholder = placeholder
    @title = title
    @type = type
  end

  def render?
    @search_path
  end
end
