module DmUniboCommon::ApplicationHelper
  def main_title(srt)
    srt = srt.to_s unless srt.is_a?(String)
    content_tag(:h1, srt)
  end

  # If user is sso logged even if he has no access should see his eppn (and logout link)
  # MMMM todo but I'am not sure. The app needs a login even if shibboleth user already logged
  def sso_user_upn
    # request.env["HTTP_EPPN"] || (current_user&.upn) || (current_user&.email)
    current_user&.upn || current_user&.email
  end

  def popover_help(title, content)
    raw %(
    <span type="button" class="float-right" title="#{content}">
      <i class="fa fa-question-circle float-end"></i>
    </span>)
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

  def class_active_val(x, y)
    (x.to_s.downcase == y.to_s.downcase) ? "active" : ""
  end

  def class_active(x, y)
    (x.to_s.downcase == y.to_s.downcase) ? 'class="active"'.html_safe : ""
  end

  def dm_card(title: "", add_class: "")
    content_tag :div, class: "dm-card #{add_class}" do
      content_tag(:div, title, class: "dm-card-title") +
        content_tag(:div, class: "dm-card-body") do
          yield
        end
    end
  end

  def mail_to_contact
    mail_to Rails.configuration.unibo_common.contact_mail, Rails.configuration.unibo_common.contact_mail
  end

  def check_user_is_cesia
    current_user.is_cesia? or raise DmUniboCommon::NotAuthorized, "Non sufficienti privilegi per seguire l'operazione"
  end

  def auth_callback_path
    dm_unibo_common.send(:"auth_#{Rails.configuration.unibo_common.omniauth_provider}_callback_path")
  end
end
