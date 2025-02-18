import { Controller } from "@hotwired/stimulus";
import { Turbo } from "@hotwired/turbo-rails";

export default class extends Controller {
  connect() {
    const textarea = this.element.querySelector("#note_content");
    if (!textarea) return; // Only proceed if the textarea is present

    // Create a countdown display element below the form with Tailwind styling
    this.countdownEl = document.createElement("div");
    this.countdownEl.className = "mt-2 text-xs text-gray-500";
    this.countdownEl.innerHTML = `
      <div id="autosave-countdown"></div>
      <div id="autoreload-countdown"></div>
    `;
    // Insert the countdown element after the form element
    this.element.insertAdjacentElement("afterend", this.countdownEl);

    let autoSaveTimeout; // Timer for auto-save after inactivity
    let reloadTimeout;   // Timer for auto-reloading the page
    let autoSaveCountdownInterval;
    let autoReloadCountdownInterval;

    const AUTO_SAVE_DELAY = 5000;     // 5 seconds for auto-save
    const AUTO_RELOAD_DELAY = 120000;   // 2 minutes for auto-reload

    const autosaveCountdownEl = this.countdownEl.querySelector("#autosave-countdown");
    const autoreloadCountdownEl = this.countdownEl.querySelector("#autoreload-countdown");

    const clearAutoSaveCountdown = () => {
      if (autoSaveCountdownInterval) {
        clearInterval(autoSaveCountdownInterval);
        autoSaveCountdownInterval = null;
      }
      autosaveCountdownEl.textContent = "";
    };

    const clearAutoReloadCountdown = () => {
      if (autoReloadCountdownInterval) {
        clearInterval(autoReloadCountdownInterval);
        autoReloadCountdownInterval = null;
      }
      autoreloadCountdownEl.textContent = "";
    };

    // Function to schedule an auto-reload via Turbo
    const scheduleReload = () => {
      clearAutoReloadCountdown();
      const startTime = Date.now();
      reloadTimeout = setTimeout(() => {
        Turbo.visit(window.location.href, { action: "replace" });
      }, AUTO_RELOAD_DELAY);

      autoReloadCountdownInterval = setInterval(() => {
        const elapsed = Date.now() - startTime;
        const remaining = Math.max(0, Math.ceil((AUTO_RELOAD_DELAY - elapsed) / 1000));
        autoreloadCountdownEl.textContent = `Auto-reload in: ${remaining} seconds`;
        if (remaining <= 0) {
          clearAutoReloadCountdown();
        }
      }, 1000);
    };

    // Initially, schedule auto-reload when the page loads
    scheduleReload();

    // If the user focuses on the textarea, cancel the reload timer and its countdown
    textarea.addEventListener("focus", () => {
      if (reloadTimeout) {
        clearTimeout(reloadTimeout);
        reloadTimeout = null;
      }
      clearAutoReloadCountdown();
    });

    // Listen for input events on the textarea
    textarea.addEventListener("input", () => {
      // Clear any existing timers and countdowns when the user types
      if (autoSaveTimeout) {
        clearTimeout(autoSaveTimeout);
        autoSaveTimeout = null;
      }
      if (reloadTimeout) {
        clearTimeout(reloadTimeout);
        reloadTimeout = null;
      }
      clearAutoSaveCountdown();
      clearAutoReloadCountdown();

      // Start auto-save countdown
      const startTimeAutoSave = Date.now();
      autoSaveCountdownInterval = setInterval(() => {
        const elapsed = Date.now() - startTimeAutoSave;
        const remaining = Math.max(0, Math.ceil((AUTO_SAVE_DELAY - elapsed) / 1000));
        autosaveCountdownEl.textContent = `Auto-save in: ${remaining} seconds`;
        if (remaining <= 0) {
          clearAutoSaveCountdown();
        }
      }, 1000);

      // Schedule auto-save after 5 seconds of inactivity
      autoSaveTimeout = setTimeout(() => {
        this.element.submit(); // Auto-save the form
        clearAutoSaveCountdown();
        scheduleReload();      // Schedule reload 1 minute after auto-save
      }, AUTO_SAVE_DELAY);
    });

    // Optionally, clear timers when the form is submitted
    this.element.addEventListener("submit", () => {
      if (autoSaveTimeout) clearTimeout(autoSaveTimeout);
      if (reloadTimeout) clearTimeout(reloadTimeout);
      clearAutoSaveCountdown();
      clearAutoReloadCountdown();
    });
  }
}
