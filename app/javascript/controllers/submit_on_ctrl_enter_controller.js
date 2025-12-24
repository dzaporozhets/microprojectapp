import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["textarea"]

  connect() {
    if (this.hasTextareaTarget) {
      this.textareaTarget.addEventListener("keydown", this.handleKeydown.bind(this));
    }
  }

  disconnect() {
    if (this.hasTextareaTarget) {
      this.textareaTarget.removeEventListener("keydown", this.handleKeydown.bind(this));
    }
  }

  handleKeydown(event) {
    if ((event.ctrlKey || event.metaKey) && event.key === "Enter") {
      event.preventDefault();
      this.element.requestSubmit();
    }
  }
}
