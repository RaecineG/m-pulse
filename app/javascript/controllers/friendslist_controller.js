import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="friendslist"
export default class extends Controller {

  static targets = ["friendList", "form", "input"];

  connect() {
    console.log("i need to do")
  }

  search(event) {
    event.preventDefault();

  const url = `${this.formTarget.action}?query=${this.inputTarget.value}`;
  fetch(url, { headers: { "Accept": "text/plain" } })
    .then(response => response.text())
    .then((data) => {
      this.friendListTarget.outerHTML = data;
    });
}
}
