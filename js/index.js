import * as bootstrap from "bootstrap"
import "@fortawesome/fontawesome-free/js/regular.min"
import "@fortawesome/fontawesome-free/js/solid.min"
import "@fortawesome/fontawesome-free/js/fontawesome.min"
import "@hotwired/turbo-rails"

export { default as DmTest } from "./dm_test"
export { default as TurboModalController } from "./turbo_modal_controller"
export { default as LimitVisibleController } from "./limit_visible_controller"

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

window.toggle_div = function (boolean, first, second, with_listener = true) {
  var boolean_element = boolean.tagName ? boolean : document.querySelector(boolean);
  var first_element = first.tagName ? first : document.querySelector(first);
  var second_element = null;
  if (second) {
    second_element = second.tagName ? second : document.querySelector(second);
  }

  // console.log("IN window.toggle_div");
  // console.log(boolean_element);
  // console.log(boolean_element.checked);
  // console.log(first_element);

  if (first_element) {
    first_element.style.display = boolean_element.checked ? 'block' : 'none';
  }
  if (second_element) {
    second_element.style.display = boolean_element.checked ? 'none' : 'block';
  }

  if (boolean_element && with_listener) {
    boolean_element.addEventListener('change', function() { 
      toggle_div(boolean_element, first_element, second_element, false);
    });
  }
};

window.toggleVisible = function (item) {
    if (item.style.display === 'none'){
        item.style.display = 'block';
    } else {
        item.style.display = 'none';
    }
};
