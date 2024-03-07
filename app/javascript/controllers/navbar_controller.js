import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="navbar"
export default class extends Controller {
  static targets = ["icon"]

  connect() {
  }

  changeColor(event) {
    // Remove active class from all icons
    this.iconTargets.forEach((icon) => {
      icon.classList.remove('icon-active');
    });

    // Add active class to the clicked icon
    event.currentTarget.classList.add('icon-active');
  }
}
