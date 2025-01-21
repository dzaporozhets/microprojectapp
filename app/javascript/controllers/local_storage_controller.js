import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["textarea"];

  connect() {
    const documentId = this.element.dataset.documentId; // Get the document ID from the data attribute
    const storageKey = `document-content-${documentId}`; // Create a unique key using the document ID
    const textarea = this.textareaTarget;

    // Load content from localStorage when the page loads
    if (localStorage.getItem(storageKey)) {
      textarea.value = localStorage.getItem(storageKey);
    }

    // Save content to localStorage every time the user types
    textarea.addEventListener("input", () => {
      localStorage.setItem(storageKey, textarea.value);
    });

    // Optional: Clear localStorage for this document on form submission
    this.element.addEventListener("submit", () => {
      localStorage.removeItem(storageKey);
    });
  }
}
