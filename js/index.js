import * as bootstrap from "bootstrap"
import "@hotwired/turbo-rails"
export { TurboModalController } from "./turbo_modal_controller"

window.display_unless = function (txt, what, condition_input) {
  what.style.display = (condition_input.value == txt) ? 'none' : 'block';
  condition_input.addEventListener('change', () => {
    console.log(condition_input.value);
    what.style.display = (condition_input.value === txt) ? 'none' : 'block';
  });
}

window.display_if = function (txt, what, condition_input) {
  what.style.display = (condition_input.value == txt) ? 'block' : 'none';
  condition_input.addEventListener('change', () => {
    console.log(condition_input.value);
    what.style.display = (condition_input.value === txt) ? 'block' : 'none';
  });
}

window.display_if_checked = function (what, condition_input) {
  if (what && condition_input) {
    what.style.display = (condition_input.checked) ? 'block' : 'none';
    condition_input.addEventListener('change', () => {
      console.log(condition_input.checked);
      what.style.display = (condition_input.checked) ? 'block' : 'none';
    });
  }
}


