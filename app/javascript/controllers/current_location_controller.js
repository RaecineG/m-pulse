import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="current-location"

export default class extends Controller {

  static values = {
    apiKey: String,
    markers: Array,
  }

  connect() {
    if ("geolocation" in navigator) {
      // Get the current position
      navigator.geolocation.getCurrentPosition(
        this.handleSuccess.bind(this),
        this.handleError.bind(this)
      );
    } else {
      // Geolocation is not supported by this browser
      console.log("Geolocation is not supported by this browser.");
    }
  }

  handleSuccess(position) {
    // Get latitude and longitude

    const latitude = position.coords.latitude;
    const longitude = position.coords.longitude;


    console.log("Latitude: " + latitude + ", Longitude: " + longitude);

    const mapElement = document.querySelector('.background-map');
  　const map = mapElement._map;
   console.log(mapElement);

  // Add a marker to the map at the retrieved coordinates
  new mapboxgl.Marker()
    .setLngLat([longitude, latitude])
    .addTo(map);

  }



  handleError(error) {
    // Handle any errors that occur while retrieving the position
    console.error("Error getting location:", error);
  }
}
