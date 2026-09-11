import { Controller } from "@hotwired/stimulus"
import * as bootstrap from "bootstrap"

class TurboModalController extends Controller {
  static targets = ["modalContent"]

  connect() {
    this.modalDiv = document.getElementById("modal_div");
    this.modalContent = document.getElementById("modal_content"); // to locate click
    this.modal = bootstrap.Modal.getOrCreateInstance(this.modalDiv);
    this.modal.show()
  }

  showModal() {
  }

  hideModal() {
    // Without this, turbo won't re-open the modal on subsequent clicks
    this.element.parentElement.removeAttribute("src")
    this.element.remove()
    this.modal.hide()
  }

  // hide modal on successful form submission
  // action: "turbo:submit-end->turbo-modal#submitEnd"
  // https://turbo.hotwired.dev/reference/events
  submitEnd(e) {
    if (e.detail.success) {
      this.hideModal()
    }
  }

  followLink(e) {
    this.hideModal()
  }

  closeWithKeyboard(e) {
    if (e.code == "Escape") {
      this.hideModal()
    }
  }

  closeBackground(e) {
    if (e && this.modalContent.contains(e.target)) {
      return
    }
    this.hideModal()
  }
}

export { TurboModalController as default };
