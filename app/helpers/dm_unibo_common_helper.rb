module DmUniboCommonHelper 

  def main_title(srt)
    srt = srt.to_s unless srt.is_a?(String)
    if modal_page
      javascript_tag("$('#main-modal .modal-title').html('#{j srt}')")
    else
      content_tag(:h1, srt)
    end
  end

  def icon(name, text: "", size: 18, reg: nil)
    content_tag(:i, '', style: "font-size: #{size}px", class: "#{reg ? 'far' : 'fa'} fa-#{name}") + " " + text
  end

  def fwicon(name, text: "", size: 18, reg: nil)
    raw "<i style=\"font-size: #{size}px\" class=\"fa fa-#{name} fa-fw\"></i> #{text}"
  end

  def big_icon(name, size: 26, reg: nil)
    icon(name, size: size, reg: reg)
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
      <div class="modal fade" id="main-modal" tabindex="-1" role="dialog" aria-labelledby="main_modal" aria-hidden="true">
        <div class="modal-dialog modal-lg" role="document">
          <div class="modal-content">
            <div class="modal-header">
              <h5 class="modal-title"></h5>
              <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true" style="font-size: 42px">&times;</span></button>
            </div>
            <div class="modal-body">
            </div>
            <div class="modal-footer">
            </div>
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
      next if message.blank?

      type = type.to_sym
      type = :success if type.to_s == :notice.to_s
      type = :danger  if type.to_s == :alert.to_s
      type = :danger  if type.to_s == :error.to_s
      next unless ALERT_TYPES.include?(type)

      icon = (type == :danger) ? 'exclamation-triangle' : 'info-circle'

      Array(message).each do |msg|
        text = content_tag(:div,
                           icon(icon) + ' ' + h(msg) + '<button type="button" class="close" data-dismiss="alert" aria-label="Close"><span aria-hidden="true">&times;</span></button>'.html_safe,
                           class: "alert alert-#{type} alert-dismissible fade show", role: 'alert')
        flash_messages << text if msg
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

  def dm_card(title: '')
    content_tag :div, class: 'dm-card' do
      content_tag(:div, title, class: 'dm-card-title') +
      content_tag(:div, class: 'dm-card-body') do
        yield
      end
    end
  end

  def dm_modal_js_helper
    javascript_tag do
      raw %Q|
  $('.modal-link').click(function(event){
    event.preventDefault();
    var url = $(this).attr('href');
    var separator = url.indexOf('?') > -1 ? '&' : '?';
    $('#main-modal .modal-body').load(url + separator + "modal=yyy");
    $('#main-modal').modal('show');
  });
  |
    end
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
