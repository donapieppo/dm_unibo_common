# frozen_string_literal: true

#require "turbo-rails"
# ActiveSupport.on_load(:action_controller_base) do
#   helper Turbo::Engine.helpers
#   include Turbo::FramesHelper
# end

class DmUniboCommon::ModalComponent < ViewComponent::Base
  def initialize(title: "", hidden: false, noactions: false)
    @title = title
    @hidden = hidden
    @actions = noactions ? "" : "turbo:click->turbo-modal#followLink
                                 keyup@window->turbo-modal#closeWithKeyboard
                                 click@window->turbo-modal#closeBackground
                                 turbo:submit-end->turbo-modal#submitEnd"
  end
end
