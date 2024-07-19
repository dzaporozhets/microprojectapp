import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input"];

  connect() {
    const form = this.element.querySelector('form');
    if (!form || form.id !== 'new_task_form') return;

    this.inputElement = document.getElementById('task_name');
    form.addEventListener("keydown", this.handleKeydown.bind(this));
  }

  disconnect() {
    const form = this.element.querySelector('form');
    if (form) {
      form.removeEventListener("keydown", this.handleKeydown.bind(this));
    }
  }

  handleKeydown(event) {
    if ((event.metaKey || event.ctrlKey) && event.key === "Enter") {
      event.preventDefault();
      this.element.querySelector('form').requestSubmit();
    }
  }
}

