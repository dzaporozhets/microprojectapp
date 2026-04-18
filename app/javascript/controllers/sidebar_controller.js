import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="sidebar"
export default class extends Controller {
  static targets = ["panel"];

  toggle() {
    this.panelTarget.classList.toggle("-translate-x-full");
  }
}
