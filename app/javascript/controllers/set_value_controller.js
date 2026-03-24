import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  set(event) {
    event.preventDefault()
    const targetId = event.currentTarget.dataset.targetId
    const value = event.currentTarget.dataset.value
    document.getElementById(targetId).value = value
  }

  focus(event) {
    event.preventDefault()
    const targetId = event.currentTarget.dataset.targetId
    document.getElementById(targetId).focus()
  }
}
