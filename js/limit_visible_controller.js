import { Controller } from "@hotwired/stimulus"

class LimitVisibleController extends Controller {
        static targets = ["item"]

        connect() {
                console.log("dm_unibo_common limit visible connected")
        }

        update(e) {
                const input = e.target.value.trim();
                console.log(`update with ${input}`)
                this.itemTargets.forEach( (o) => {
                        o.style.display = (o.dataset.text.includes(input)) ? 'flex' : 'none';
                });
        }
}

export { LimitVisibleController as default };
