import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="checkin"
export default class extends Controller {
  static targets = ["card", "button"]

  connect() {
    console.log("hello")
  }

  noauto(event) {
    event.preventDefault()
    console.log("clicked!");
  }

  showCheckin(event) {
    console.log(event)
    this.cardTarget.classList.toggle("d-none")
    this.buttonTarget.classList.toggle("d-none")
  }

}
