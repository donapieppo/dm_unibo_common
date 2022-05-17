# frozen_string_literal: true

#require "turbo-rails"
# ActiveSupport.on_load(:action_controller_base) do
#   helper Turbo::Engine.helpers
#   include Turbo::FramesHelper
# end

class DmUniboCommon::ModalComponent < ViewComponent::Base
  def initialize(title: "", hidden: false)
    @title = title
    @hidden = hidden
  end
end

