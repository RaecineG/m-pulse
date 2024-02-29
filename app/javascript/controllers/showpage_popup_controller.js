import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="showpage-popup"
export default class extends Controller {

  static targets = ["card", "category"];


  connect() {
    this.filterEventsByCategory("");
    console.log("Event card targets:", this.categoryTargets);
    // console.log(this.categoryValue);
    // console.log(this.inputTarget.value);



    }

  filterEventsByCategory(category) {
    console.log("Selected Category:", category);
    // console.log(categoryTargets)


    this.categoryTargets.forEach(card => {
      const cardCategory = card.dataset.showpagePopupCategoryValue;
      console.log("Card Category:", cardCategory);

      if (category === "" || category === "All Categories" || category === cardCategory) {
        console.log("Show card with category:", cardCategory);
        card.style.display = "flex"; // Show the card
      } else {
        console.log("Hide card with category:", cardCategory);
        card.style.display = "none"; // Hide the card
      }
    });
  }

  selectCategory(event) {
    const selectedCategory = event.target.value;
    this.filterEventsByCategory(selectedCategory);
  }

  openCard() {

    const class_name = this.cardTarget.id;
    const eventCard= document.getElementById(`marker_${class_name}`);
    console.log(eventCard);

    const modalButton = document.getElementById("modal-button");

    // const isExpanded = eventCard.getAttribute("aria-expanded") === "true";
    // eventCard.setAttribute("aria-expanded", isExpanded ? "false" : "true");

    eventCard.click();
    modalButton.click();

  }
  // update() {

  //     const url = `${this.formTarget.action}?query=${this.inputTarget.value}`;
  //     fetch(url, { headers: { "Accept": "text/plain" } })
  //       .then(response => response.text())
  //       .then((data) => {
  //         this.eventNameTarget.outerHTML = data;
  //       });

  // }
}
