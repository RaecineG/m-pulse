import { Controller } from "@hotwired/stimulus"
import Autosave from 'stimulus-rails-autosave'

export default class extends Autosave {
  static values = {
    delay: {
      type: Number,
      default: 1000, // You can change the default delay here.
    },
  }

  connect() {
    super.connect()
  }

  save() {
    super.save()
    setTimeout(()=>{
      location.reload()}, 5000
    )
  }
}
