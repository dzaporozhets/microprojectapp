import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="hide-div"
export default class extends Controller {
  static values = { delay: Number };

  connect() {
    setTimeout(() => {
      this.element.style.opacity = "0";
      this.element.style.transition = "opacity 1s ease";
      setTimeout(() => this.element.style.display = "none", 1000);
    }, this.delayValue || 5000); // Default to 5 seconds if no value is set
  }
}
