module DmUniboModalHelper

  def modal_link_to(name, url, addclass: '')
    link_to name, url, class: "modal-link #{addclass}", modal: true
  end

  # def link_to_modal_edit(url)
  #   link_to icon('edit'), url, title: 'Inserisci/modifica dati', data: { toggle: "modal", target: "#main-modal" }
  # end

  # def link_to_modal_new(name = "", url)
  #   link_to icon('plus-circle') + " " + name, url, class: :button, data: { toggle: "modal", target: "#main-modal" }
  # end

  # def main_title(srt)
  #   srt = srt.to_s unless srt.is_a?(String)
  #   if modal_page
  #     javascript_tag("$('#main-modal .modal-title').html('#{j srt}')")
  #   else
  #     content_tag(:h1, srt)
  #   end
  # end

  # def dm_modal_js_helper
  #   javascript_tag do
  #     raw %Q|
  # modal = document.querySelector('#main-modal .modal-body');
  # document.querySelectorAll('.modal-link').forEach( (element) => {
  #   element.addEventListener('click', (event) => {
  #     event.preventDefault();
  #     var url = element.getAttribute('href');
  #     var separator = url.indexOf('?') > -1 ? '&' : '?';
  #     fetch(url + separator + "modal=yyy").then( res => {
  #       modal.innerHTML = res;
  #       modal.style.display = 'block';
  #     });
  #   });
  # });
  #     |
  #   end
  # end

  def bootstrap_modal_div
    raw %Q|
<div class="modal fade" id="mainModal" tabindex="-1" aria-labelledby="mainModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-lg">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="mainModalLabel"></h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
      <div class="modal-body">
      </div>
      <div class="modal-footer">
      </div>
    </div>
  </div>
</div>
    |
  end
end
