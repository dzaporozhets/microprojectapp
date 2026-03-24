import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["source"]

  copy(event) {
    const text = this.sourceTarget.textContent
    navigator.clipboard.writeText(text).then(() => {
      const button = event.currentTarget
      const original = button.textContent
      button.textContent = "Copied!"
      setTimeout(() => { button.textContent = original }, 2000)
    })
  }
}
