module DmUniboLinkHelper

  def link_to_back url
    link_to 'indietro', url, data: { turbo: false }
  end

  def link_to_delete(name = "", url, button: false, _class: '')
    button_to url, method: :delete, title: 'elimina', form: { data: { 'turbo-confirm': 'Siete sicuri di voler cancellare?'}, 
                                                              class: "d-inline px-0 mx-0 #{_class}" } do
      fwdmicon('trash-alt', text: name)
    end
  end

  def link_to_download(url, txt = "")
    link_to fwdmicon('download') + txt, url
  end

  def link_to_show(name = "", url)
    link_to dmicon('search', text: name), url, title: "Mostra dettagli"
  end

  def link_to_edit(name = "", url, button: false)
    link_to fwdmicon('edit', text: name), url, title: "Inserisci/modifica dati", class: (button ? 'button ' : '') 
  end

  def link_to_new(name = "", url, button: true)
    link_to fwdmicon('plus-circle', text: name), url, class: (button ? 'button ' : '') 
  end

  # IMPERSONATION
  def stop_impersonation_link
    if (current_user == true_user)
      "" 
    else
      "You (#{h true_user.upn}) are impersonating <strong>#{h current_user.upn}</strong><br/> #{link_to fwdmicon('reply') + " back to admin", dm_unibo_common.stop_impersonating_path}".html_safe
    end
  end

  def start_impersonation_link
    if true_user_can_impersonate?
      link_to fwdmicon('user') + " impersona", dm_unibo_common.who_impersonate_path
    end
  end

  def support_mail
    mail = Rails.configuration.dm_unibo_common[:support_mail]
    "<a href='mailto: #{mail}'>#{mail}</a>".html_safe
  end

  def assistenza_cesia
    '<a href="mailto:assistenza.cesia@unibo.it">assistenza.cesia@unibo.it</a>'.html_safe
  end
end
