import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="navbar"
export default class extends Controller {
  static targets = ["homeIcon", "dashboardIcon", "eventsIcon", "friendsIcon"]

  connect() {
    console.log(this.homeIconTarget)
    // get the url of the current page
    const currentUrl = window.location.pathname;
    // if url is .../events apply dark color to home icon target
    if (currentUrl === "/events") {
      this.homeIconTarget.style.color = "#FAFD69";
    }
    // if url is .../dashboard apply dark color to dashboard icon
    if (currentUrl === "/dashboard") {
      this.dashboardIconTarget.style.color = "#FAFD69";
    }

    if (currentUrl === "/follows") {
      this.friendsIconTarget.style.color = "#FAFD69";
    }
  }

  // changeColor(event) {
  //   // Remove active class from all icons
  //   this.iconTargets.forEach((icon) => {
  //     icon.classList.remove('icon-active');
  //   });

    // Add active class to the clicked icon
    // event.currentTarget.classList.add('icon-active');

}
