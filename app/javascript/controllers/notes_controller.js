import { Controller } from "@hotwired/stimulus";
import { Turbo } from "@hotwired/turbo-rails";

export default class extends Controller {
  connect() {
    const textarea = this.element.querySelector("#note_content");
    if (!textarea) return; // Only proceed if the textarea is present

    let autoSaveTimeout; // Timer for auto-save after 3 seconds of inactivity
    let reloadTimeout;   // Timer for reloading the page after 1 minute

    // Function to schedule a reload in 1 minute
    const scheduleReload = () => {
      reloadTimeout = setTimeout(() => {
        Turbo.visit(window.location.href, { action: "replace" });
      }, 60000); // 1 minute
    };

    // On page load, schedule the reload timer
    scheduleReload();

    // If the user focuses on the textarea, kill the reload timer
    textarea.addEventListener("focus", () => {
      if (reloadTimeout) {
        clearTimeout(reloadTimeout);
        reloadTimeout = null;
      }
    });

    // Listen for input events on the textarea
    textarea.addEventListener("input", () => {
      // Clear any existing timers immediately when user starts typing
      if (autoSaveTimeout) {
        clearTimeout(autoSaveTimeout);
        autoSaveTimeout = null;
      }
      if (reloadTimeout) {
        clearTimeout(reloadTimeout);
        reloadTimeout = null;
      }

      // When user stops typing for 3 seconds, trigger auto-save and schedule reload
      autoSaveTimeout = setTimeout(() => {
        this.element.submit(); // Auto-save (auto-submit) the form
        scheduleReload();      // Schedule reload 1 minute after auto-save
      }, 3000); // 3,000 ms = 3 seconds
    });

    // Optionally, clear timers when the form is submitted
    this.element.addEventListener("submit", () => {
      if (autoSaveTimeout) clearTimeout(autoSaveTimeout);
      if (reloadTimeout) clearTimeout(reloadTimeout);
    });
  }
}
