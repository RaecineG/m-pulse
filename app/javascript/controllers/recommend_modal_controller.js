import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="recommend-modal"
export default class extends Controller {

  static targets = ["overlay"]
  connect() {

    // <!-- JavaScript for Modal -->
  }
  open() {
    this.overlayTarget.style.display = "flex";
  }

  close() {
    this.overlayTarget.style.display = "none";
  }

}
