import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="recommend-modal"
export default class extends Controller {

  static targets = ["overlay"]
  connect() {

    // <!-- JavaScript for Modal -->
  }

  toggleModal() {
    if (this.overlayTarget.style.display === "none" || this.overlayTarget.style.display === "") {
      this.open();
    } else {
      this.close();
    }
  }
  open() {
    this.overlayTarget.style.display = "flex";
  }

  close() {
    this.overlayTarget.style.display = "none";
  }

}
