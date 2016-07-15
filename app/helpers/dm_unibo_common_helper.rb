module DmUniboCommonHelper 

  def icon(name, options = { text: "", size: "18" })
    raw "<i style=\"font-size: #{options[:size]}px\" class=\"fa fa-#{name}\"></i> #{options[:text]}"
  end

  def fwicon(name, options = { text: "", size: "18" })
    raw "<i style=\"font-size: #{options[:size]}px\" class=\"fa fa-#{name} fa-fw\"></i> #{options[:text]}"
  end

  def big_icon(name, options = {})
    icon(name, options.update(size: 26))
  end

  # If user is sso logged even if he has no access should see his eppn (and logout link)
  def sso_user_upn
    request.env['HTTP_EPPN'] || (current_user and current_user.upn) || (current_user and current_user.email) 
  end

  # in confiiguration dm_unibo_common[:impersonate_admins] is array of upn/email that can
  # impersonate (gem pretender)
  def true_user_can_impersonate?
    true_user and Rails.configuration.dm_unibo_common[:impersonate_admins] and Rails.configuration.dm_unibo_common[:impersonate_admins].include?(true_user.upn)
  end

  def bootstrap_modal_div
    raw %Q|
      <div class="modal fade" id="main-modal" >
        <div class="modal-dialog">
          <div class="modal-content">
          </div><!-- .modal-content -->
        </div><!-- .modal-dialog -->
      </div><!-- .modal -->
      |
  end

  # from https://github.com/seyhunak/twitter-bootstrap-rails
  ALERT_TYPES = [:success, :info, :warning, :danger]
  def bootstrap_flash
    flash_messages = []
    flash.each do |type, message|
      # Skip empty messages, e.g. for devise messages set to nothing in a locale file.
      next if message.blank?

      type = type.to_sym
      type = :success if type.to_s == :notice.to_s
      type = :danger if type.to_s == :alert.to_s
      type = :danger if type.to_s == :error.to_s
      next unless ALERT_TYPES.include?(type)

      Array(message).each do |msg|
        text = content_tag(:div,
                           content_tag(:button, raw("&times;"), :class => "close", "data-dismiss" => "alert") +
                           msg, :class => "alert fade in alert-#{type}")
        flash_messages << text if msg
      end
    end
    flash_messages.join("\n").html_safe
  end

  def tooltip(key)
    message = Tooltip.message(key)
    raw %$<h3 class="info"> $ + image_tag("info.png", :width => '15') + 
        %$ #{message[0]} <span>#{message[1]}</span></h3>$
  end

  def popover_help(title, content)
    raw %Q|<i class="fa fa-question-circle pull-right popover-help" data-placement="left" data-toggle="popover" title="#{title}" data-content="#{content}"></i>|
  end

  # dl_field(User.first, :name)
  # dl_field(:user_name, "Pietro)
  def dl_field(object, what)
    if object.is_a?(Symbol)
      content_tag(:dt, I18n.t(object).capitalize) + 
      content_tag(:dd, what)
    else
      content_tag(:dt, I18n.t("activerecord.attributes.#{object.class.to_s.downcase}.#{what}").capitalize) + 
      content_tag(:dd, object.send(what)) # what is a symbol
    end
  end

  def class_active(x,y)
    x == y ? 'class="active"'.html_safe : ''
  end
end

#module SimpleForm
#  module Inputs
#
#    class DatePickerInput < Base
#      def input
#        @builder.text_field(attribute_name,input_html_options)
#      end    
#    end
#  end
#end
#
