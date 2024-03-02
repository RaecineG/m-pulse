import { Controller } from "@hotwired/stimulus"
import { createConsumer } from "@rails/actioncable"

// Connects to data-controller="event-subscription"
export default class extends Controller {
  static values = { eventId: Number }
  static targets = ["comments"]

  connect() {
    this.channel = createConsumer().subscriptions.create(
      { channel: "EventChannel", id: this.eventIdValue },
      { received: data => console.log(data) }
    )
    console.log(`Subscribed to the event with the id ${this.eventIdValue}.`)
  }
}
