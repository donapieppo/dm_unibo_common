import { Controller } from "@hotwired/stimulus"

class LimitVisibleController extends Controller {
        static targets = ["item"]
        static values = { display: String, default: 'block' }

        connect() {
                console.log(`dm_unibo_common limit visible connected on ${display}`")
        }

        update(e) {
                const input = e.target.value.trim();
                console.log(`update with ${input}`)
                this.itemTargets.forEach( (o) => {
                        o.style.display = (o.dataset.text.includes(input)) ? this.displayValue : 'none';
                });
        }
}

export { LimitVisibleController as default };
