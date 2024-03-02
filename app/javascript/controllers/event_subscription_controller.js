import { Controller } from "@hotwired/stimulus"
import { createConsumer } from "@rails/actioncable"

// Connects to data-controller="event-subscription"
export default class extends Controller {
  static values = { eventId: Number }
  static targets = ["comments"]

  connect() {
    this.channel = createConsumer().subscriptions.create(
      { channel: "EventChannel", id: this.eventIdValue },
      { received: data => this.#insertCommentAndScrollDown(data) }
    )
    console.log(`Subscribed to the event with the id ${this.eventIdValue}.`)
  }

  disconnect() {
    console.log("Unsubscribed from the chatroom")
    this.channel.unsubscribe()
  }

  resetForm(event) {
    event.target.reset()
  }

  #insertCommentAndScrollDown(data) {
    this.commentsTarget.insertAdjacentHTML("beforeEnd", data)
    this.commentsTarget.scrollTo(0, this.commentsTarget.scrollHeight)
  }
}
