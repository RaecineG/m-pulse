import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="showpage-popup"
export default class extends Controller {

  static targets = ["card"]
  connect() {

  }

  openCard() {
    // event.preventDefault()
    const class_name = this.cardTarget.id
    const eventCard= document.getElementById(`marker_${class_name}`)
    console.log(eventCard)
    eventCard.click()
    // eventCard.setAttribute('aria-expanded', String("true"));



}
}
