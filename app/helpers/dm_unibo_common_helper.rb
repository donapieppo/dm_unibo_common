include DmUniboMenuHelper
include DmUniboPrivacyHelper 
include DmUniboFormHelper
include DmUniboLinkHelper
include DmUniboModalHelper
include DmUniboOrganizationsHelper

module DmUniboCommonHelper 
  def main_title(srt)
    srt = srt.to_s unless srt.is_a?(String)
    if false and modal_page
      javascript_tag("document.querySelector('#main-modal .modal-title').innerHTML = '#{j srt}'")
    else
      content_tag(:h1, srt)
    end
  end

  def dmicon(name, text: "", size: 18, prefix: 'fas', style: '')
    content_tag(:i, '', style: "font-size: #{size}px; #{style}", class: "#{prefix} fa-#{name}") + " " + text
  end

  def fwdmicon(name, text: "", size: 18, prefix: 'fas')
    raw "<i style=\"font-size: #{size}px\" class=\"#{prefix} fa-#{name} fa-fw\"></i>#{text}"
  end

  def big_dmicon(name, text: "", size: 24, prefix: 'fas')
    dmicon(name, text: text, size: size, prefix: prefix)
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

  # from https://github.com/seyhunak/twitter-bootstrap-rails
  ALERT_TYPES = [:success, :info, :warning, :danger]
  def bootstrap_flash
    flash_messages = []
    flash.each do |type, message|
      next if message.blank?

      type = type.to_sym
      type = :success if type.to_s == :notice.to_s
      type = :danger  if type.to_s == :alert.to_s
      type = :danger  if type.to_s == :error.to_s
      next unless ALERT_TYPES.include?(type)

      i = (type == :danger) ? 'exclamation-triangle' : 'info-circle'

      Array(message).each do |msg|
        text = content_tag(:div, dmicon(i) + ' ' + msg.html_safe,  
                           class: "alert alert-#{type}", role: 'alert')
        flash_messages << text.html_safe if msg
      end
    end
    flash_messages.join("\n").html_safe
  end

  def tooltip(key)
    message = Tooltip.message(key)
    raw %$<h3 class="info"> $ + image_tag("info.png", width: '15') + 
        %$ #{message[0]} <span>#{message[1]}</span></h3>$
  end

  def popover_help(title, content)
    raw %Q|<span class="float-right"><i class="fa fa-question-circle pull-right popover-help" data-placement="left" data-toggle="popover" title="#{title}" data-content="#{content}"></i></span>|
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

  def class_active_val(x,y)
    (x.to_s.downcase == y.to_s.downcase) ? 'active' : ''
  end

  def class_active(x,y)
    (x.to_s.downcase == y.to_s.downcase) ? 'class="active"'.html_safe : ''
  end

  def dm_card(title: '', add_class: '')
    content_tag :div, class: "dm-card #{add_class}" do
      content_tag(:div, title, class: 'dm-card-title') +
      content_tag(:div, class: 'dm-card-body') do
        yield
      end
    end
  end

  def mail_to_contact
    mail_to Rails.configuration.contact_mail, Rails.configuration.contact_mail
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
