import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["textarea"];

  connect() {
    const documentId = this.element.dataset.documentId; // Get the document ID from the data attribute
    if (!documentId) return; // Do not save if document ID is not present

    const storageKey = `document-content-${documentId}`; // Create a unique key using the document ID
    const textarea = this.textareaTarget;

    // Ensure cached value is only rendered if it matches the current document ID
    const cachedValue = localStorage.getItem(storageKey);
    if (cachedValue !== null && cachedValue !== "" && localStorage.getItem("current-document-id") === documentId) {
      textarea.value = cachedValue;
    }

    localStorage.setItem("current-document-id", documentId);

    // Save content to localStorage every time the user types
    textarea.addEventListener("input", () => {
      localStorage.setItem(storageKey, textarea.value);
    });

    // Clear localStorage for this document on form submission
    this.element.addEventListener("submit", () => {
      localStorage.removeItem(storageKey);
      localStorage.removeItem("current-document-id");
    });

    // Ensure compatibility with Turbo by resetting the field when Turbo renders a new frame
    document.addEventListener("turbo:before-cache", () => {
      localStorage.setItem(storageKey, textarea.value);
    });

    document.addEventListener("turbo:load", () => {
      const cachedValue = localStorage.getItem(storageKey);
      if (localStorage.getItem("current-document-id") === documentId && cachedValue !== null && cachedValue !== "") {
        textarea.value = cachedValue;
      }
    });
  }
}
