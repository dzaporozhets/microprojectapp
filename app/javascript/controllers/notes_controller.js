import { Controller } from "@hotwired/stimulus";
import { Turbo } from "@hotwired/turbo-rails";

export default class extends Controller {
  connect() {
    this.textarea = this.element.querySelector("#note_content");
    if (!this.textarea) return; // Only proceed if the textarea is present

    // Create a countdown display element below the form with Tailwind styling
    this.countdownEl = document.createElement("div");
    this.countdownEl.className = "mt-2 text-xs text-gray-500";
    this.countdownEl.innerHTML = `
      <div id="autosave-countdown"></div>
      <div id="autoreload-countdown"></div>
    `;
    this.element.insertAdjacentElement("afterend", this.countdownEl);

    // Define delays
    this.AUTO_SAVE_DELAY = 5000;      // 5 seconds for auto-save
    this.AUTO_RELOAD_DELAY = 120000;  // 2 minutes for auto-reload

    // Grab countdown elements
    this.autosaveCountdownEl = this.countdownEl.querySelector("#autosave-countdown");
    this.autoreloadCountdownEl = this.countdownEl.querySelector("#autoreload-countdown");

    // Initialize timer variables
    this.autoSaveTimeout = null;
    this.reloadTimeout = null;
    this.autoSaveCountdownInterval = null;
    this.autoReloadCountdownInterval = null;

    // Helper: Clear auto-save countdown
    this.clearAutoSaveCountdown = () => {
      if (this.autoSaveCountdownInterval) {
        clearInterval(this.autoSaveCountdownInterval);
        this.autoSaveCountdownInterval = null;
      }
      this.autosaveCountdownEl.textContent = "";
    };

    // Helper: Clear auto-reload countdown
    this.clearAutoReloadCountdown = () => {
      if (this.autoReloadCountdownInterval) {
        clearInterval(this.autoReloadCountdownInterval);
        this.autoReloadCountdownInterval = null;
      }
      this.autoreloadCountdownEl.textContent = "";
    };

    // Helper: Schedule auto-reload via Turbo
    this.scheduleReload = () => {
      this.clearAutoReloadCountdown();
      const startTime = Date.now();
      this.reloadTimeout = setTimeout(() => {
        Turbo.visit(window.location.href, { action: "replace" });
      }, this.AUTO_RELOAD_DELAY);

      this.autoReloadCountdownInterval = setInterval(() => {
        const elapsed = Date.now() - startTime;
        const remaining = Math.max(0, Math.ceil((this.AUTO_RELOAD_DELAY - elapsed) / 1000));
        this.autoreloadCountdownEl.textContent = `Auto-reload in: ${remaining} seconds`;
        if (remaining <= 0) {
          this.clearAutoReloadCountdown();
        }
      }, 1000);
    };

    // On page load, schedule auto-reload
    this.scheduleReload();

    // When the user focuses on the textarea, cancel the reload timer and its countdown
    this.textarea.addEventListener("focus", () => {
      if (this.reloadTimeout) {
        clearTimeout(this.reloadTimeout);
        this.reloadTimeout = null;
      }
      this.clearAutoReloadCountdown();
    });

    // Listen for input events on the textarea
    this.textarea.addEventListener("input", () => {
      // Clear existing timers and countdowns on input
      if (this.autoSaveTimeout) {
        clearTimeout(this.autoSaveTimeout);
        this.autoSaveTimeout = null;
      }
      if (this.reloadTimeout) {
        clearTimeout(this.reloadTimeout);
        this.reloadTimeout = null;
      }
      this.clearAutoSaveCountdown();
      this.clearAutoReloadCountdown();

      // Start auto-save countdown
      const startTimeAutoSave = Date.now();
      this.autoSaveCountdownInterval = setInterval(() => {
        const elapsed = Date.now() - startTimeAutoSave;
        const remaining = Math.max(0, Math.ceil((this.AUTO_SAVE_DELAY - elapsed) / 1000));
        this.autosaveCountdownEl.textContent = `Auto-save in: ${remaining} seconds`;
        if (remaining <= 0) {
          this.clearAutoSaveCountdown();
        }
      }, 1000);

      // Schedule auto-save after 5 seconds of inactivity
      this.autoSaveTimeout = setTimeout(() => {
        this.element.submit(); // Auto-save the form
        this.clearAutoSaveCountdown();
        this.scheduleReload(); // Schedule reload after auto-save
      }, this.AUTO_SAVE_DELAY);
    });

    // Clear timers on form submission
    this.element.addEventListener("submit", () => {
      if (this.autoSaveTimeout) clearTimeout(this.autoSaveTimeout);
      if (this.reloadTimeout) clearTimeout(this.reloadTimeout);
      this.clearAutoSaveCountdown();
      this.clearAutoReloadCountdown();
    });
  }

  disconnect() {
    // Clear all timers when the controller disconnects
    if (this.autoSaveTimeout) clearTimeout(this.autoSaveTimeout);
    if (this.reloadTimeout) clearTimeout(this.reloadTimeout);
    if (this.autoSaveCountdownInterval) clearInterval(this.autoSaveCountdownInterval);
    if (this.autoReloadCountdownInterval) clearInterval(this.autoReloadCountdownInterval);
  }
}
