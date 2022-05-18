import * as bootstrap from "bootstrap"
import "@hotwired/turbo-rails"
export { default as DmTest } from "./dm_test"
export { default as TurboModalController } from "./turbo_modal_controller"

window.display_unless = function (txt, what, condition_input) {
  what.style.display = (condition_input.value == txt) ? 'none' : 'block';
  condition_input.addEventListener('change', () => {
    console.log(condition_input.value);
    what.style.display = (condition_input.value === txt) ? 'none' : 'block';
  });
};

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
};

window.toggle_div = function (boolean_div, first_div, second_div, with_listener = true) {
  console.log(`toggle_div on ${boolean_div} with_listener=${with_listener}`);
  check_input = document.querySelector(boolean_div);

  if (first_div && document.querySelector(first_div)) {
    document.querySelector(first_div).style.display  = check_input.checked ? 'block' : 'none';
  }
  if (second_div && document.querySelector(second_div)) {
    document.querySelector(second_div).style.display = check_input.checked ? 'none' : 'block';
  }

  if (check_input && with_listener) {
    check_input.addEventListener('change', function() { 
      toggle_div(boolean_div, first_div, second_div, false);
    });
  }
};

