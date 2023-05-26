# frozen_string_literal: true

class DmUniboCommon::SearchComponent < ViewComponent::Base
  def initialize(search_path: nil, placeholder: "", title: "")
    @search_path = search_path
    @placeholder = placeholder
    @title = title
  end

  def render?
    @search_path
  end
end
