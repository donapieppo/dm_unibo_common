# frozen_string_literal: true

# require "turbo-rails"
# ActiveSupport.on_load(:action_controller_base) do
#   helper Turbo::Engine.helpers
#   include Turbo::FramesHelper
# end

class DmUniboCommon::ModalComponent < ViewComponent::Base
  include DmUniboCommon::ApplicationHelper

  def initialize(title: "", noactions: false, size: :lg, modal_page: nil)
    @title = title
    @size = size.to_s
    @modal_page = modal_page
    @actions = noactions ? "" : "turbo:click->turbo-modal#followLink
                                 keyup@window->turbo-modal#closeWithKeyboard
                                 click@window->turbo-modal#closeBackground
                                 turbo:submit-end->turbo-modal#submitEnd"
  end

  def modal_page?
    return @modal_page unless @modal_page.nil?

    helpers.respond_to?(:modal_page?) ? helpers.modal_page? : false
  end

  def modal_attributes
    attributes = {
      id: "modal_div",
      class: "modal fade",
      tabindex: "-1",
      role: "dialog",
      aria: { modal: true }
    }

    if @title.present?
      attributes[:aria][:labelledby] = "modal_title"
    else
      attributes[:aria][:label] = "Modal"
    end

    attributes
  end
end
