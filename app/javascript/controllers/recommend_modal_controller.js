import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="recommend-modal"
export default class extends Controller {

  static targets = ["overlay", "eventsIcon", "icon"]
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
    this.iconTargets.forEach( icon => icon.style.color = "grey");
    this.eventsIconTarget.style.color = "#FAFD69";
  }

  close() {
    this.overlayTarget.style.display = "none";
  }

}
