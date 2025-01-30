module DmUniboCommonLinkHelper
  def link_to_back url
    link_to "indietro", url, data: {turbo: false}
  end

  def link_to_delete(name, url, button: false, add_class: "", size: nil, confirm_message: "Siete sicuri di voler cancellare?")
    add_class += if button
      " btn btn-danger"
    else
      " d-inline px-0 mx-0"
    end
    button_to url,
      method: :delete,
      title: "elimina",
      form_class: add_class,
      form: {data: {"turbo-confirm": confirm_message}} do
      dm_icon("trash-alt", text: name, size: size)
    end
  end

  def link_to_download(url, txt = "")
    link_to dm_icon("download", text: txt, fw: true), url
  end

  def link_to_show(name, url)
    link_to dm_icon("search", text: name, fw: true), url, title: "Mostra dettagli"
  end

  def link_to_edit(name, url, button: false)
    link_to dm_icon("edit", text: name, fw: true), url, title: "Inserisci/modifica dati", class: (button ? "button " : "")
  end

  def link_to_new(name, url, button: true)
    link_to dm_icon("plus-circle", text: name, fw: true), url, class: (button ? "button " : "")
  end

  def support_mail
    mail = Rails.configuration.unibo_common.support_mail
    %(<a href="mailto:#{mail}">#{mail}</a>).html_safe
  end

  def assistenza_cesia
    %(<a href="mailto:assistenza.cesia@unibo.it">assistenza.cesia@unibo.it</a>).html_safe
  end
end
