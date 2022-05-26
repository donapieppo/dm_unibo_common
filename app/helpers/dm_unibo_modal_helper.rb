module DmUniboModalHelper
  def modal_link_to(name, url, addclass: '')
    link_to name, url, class: "modal-link #{addclass}", modal: true
  end
end
