# frozen_string_literal: true

# The flash provides a way to pass temporary primitive-types (String, Array, Hash) between actions
# alert, notice

class DmUniboCommon::BootstrapAlertComponent < ViewComponent::Base
  def initialize(flash)
    @flash = flash
  end

  private

  def render?
    @flash.any?
  end

  def icon(type)
    case type
    when "error", "alert"
      %(<i class="fa-solid fa-circle-exclamation fa-xl"></i>).html_safe
    when "notice", "success"
      %(<i class="fa-solid fa-circle-info fa-xl"></i>).html_safe
    end
  end

  def alert_type(type)
    case type
    when "error"
      "alert alert-danger"
    when "alert"
      "alert alert-danger"
    when "notice"
      "alert alert-info"
    when "success"
      "alert alert-success"
    end
  end
end
