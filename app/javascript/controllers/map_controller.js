import { Controller } from "@hotwired/stimulus"
import mapboxgl from 'mapbox-gl'
// import MapboxGeocoder from "@mapbox/mapbox-gl-geocoder"

// Connects to data-controller="map"
export default class extends Controller {
  static values = {
    apiKey: String,
    markers: Array,
  }

  connect() {
    mapboxgl.accessToken = this.apiKeyValue

    this.map = new mapboxgl.Map({
      container: this.element,
      style: "mapbox://styles/mapbox/dark-v11"
    })

    this.#addMarkersToMap()
    this.#addCurrentLocation()
    this.#fitMapToMarkers()

    // this.getDistance()
    // this.#calculateDistance()


    this.map.addControl(new MapboxGeocoder({ accessToken: mapboxgl.accessToken, mapboxgl: mapboxgl }))
  }

  #addMarkersToMap() {
    this.markersValue.forEach((marker) => {
      const popup = new mapboxgl.Popup().setHTML(marker.info_window_html)
      new mapboxgl.Marker()
        .setLngLat([ marker.lng, marker.lat ])
        .setPopup(popup)
        .addTo(this.map)
        console.log(marker)
    })
  }

  #addCurrentLocation() {

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


    const el = document.createElement('div');
    el.className = 'current-location';

    this.map.setCenter([longitude, latitude]);


    new mapboxgl.Marker(el)
    .setLngLat([ longitude, latitude ])
    .addTo(this.map)
    this.#calculateDistance(position)

  }

  handleError(error) {
    // Handle any errors that occur while retrieving the position
    console.error("Error getting location:", error);
  }

  #fitMapToMarkers() {
    const bounds = new mapboxgl.LngLatBounds()
    this.markersValue.forEach(marker => bounds.extend([ marker.lng, marker.lat ]))
    this.map.fitBounds(bounds, { padding: 70, maxZoom: 15, duration: 0 })
  }

  #calculateDistance(position) {

      const current_x = position.coords.longitude;
      const current_y = position.coords.latitude;

      this.markersValue.forEach((marker) => {

      const event_x = marker.lng
      const event_y = marker.lat
      const event_id = marker.id;

      const coordinates = `${current_x},${current_y};${event_x},${event_y}`

      this.getDistance(coordinates, event_id)


    })
  }



  async getDistance(coordinates, event_id) {
    // Construct the API request URL
    const apiUrl = `https://api.mapbox.com/directions-matrix/v1/mapbox/walking/${coordinates}?access_token=${this.apiKeyValue}&annotations=distance`;

    try {
      // Make the API request using the Fetch API
      const response = await fetch(apiUrl);
      const data = await response.json();


      // Parse the response
      const distances = data.distances; // distances in meters
      const durations = data.durations; // travel times in seconds


      // Access specific distance or duration between two locations
      const distanceBetweenLocations = distances[0][1]; // replace with the appropriate indices

      const distanceElement = document.getElementById(`distance_${event_id}`);
        if (distanceElement) {
            distanceElement.textContent = `${(distanceBetweenLocations / 1000).toFixed(2)} km`;
        }
        console.log(distanceElement, event_id);



      console.log(distanceBetweenLocations);
      return distanceBetweenLocations;
    } catch (error) {
      console.error('Error fetching data from Mapbox Matrix API:', error);
      throw error; // Propagate the error
    }
  }



  // getDistance(coordinates) {
  //   .then(distance => {
  //     console.log(`Distance between locations: ${distance} meters`);
  //   })
  //   .catch(error => {
  //     // Handle the error
  //   });
  // }
// Make the API request using the Fetch API


}
