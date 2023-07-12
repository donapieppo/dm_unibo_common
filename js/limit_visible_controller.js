import { Controller } from "@hotwired/stimulus"

class LimitVisibleController extends Controller {
        static targets = ["item"]
        static values = { 
                substring: {type: Boolean, default: false},
                display: {type: String, default: "block"},
        }

        connect() {
                console.log(`dm_unibo_common limit visible connected on ${this.displayValue} with substring=${this.substringValue}`);
        }

        update(e) {
                var input;
                var check;

                if (e.target.type == "checkbox") {
                        // For checkbox set true / false as data-text="true"
                        input = e.target.checked.toString();
                } else {
                        input = e.target.value.trim().toLowerCase();
                }
                
                console.log(`limit visible updated with ${input}`)

                this.itemTargets.forEach((o) => {
                        if ('text' in o.dataset) {
                                if (this.substringValue) {
                                        check = o.dataset.text.includes(input)
                                } else {
                                        check = o.dataset.text == input
                                }
                                o.style.display = check ? this.displayValue : 'none';
                        }
                });
        }
}

export { LimitVisibleController as default };

// TODO
// change text -> string_to_match
