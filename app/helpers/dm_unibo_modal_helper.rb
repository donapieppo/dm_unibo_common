module DmModalHelper

  def modal_link_to(name, url)
    link_to name, url, class: 'modal-link', modal: true
  end

  def link_to_modal_edit(url)
    link_to icon('edit'), url, title: 'Inserisci/modifica dati', data: { toggle: "modal", target: "#main-modal" }
  end

  def link_to_modal_new(name = "", url)
    link_to icon('plus-circle') + " " + name, url, class: :button, data: { toggle: "modal", target: "#main-modal" }
  end

end
