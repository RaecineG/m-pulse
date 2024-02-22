import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="checkin"
export default class extends Controller {
  static targets = [
    "form"
  ]

  connect() {
    console.log("hello")
  }

  noauto(event) {
    event.preventDefault()
    console.log("clicked!");
  }

}
