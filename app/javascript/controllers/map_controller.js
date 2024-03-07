import { Controller } from "@hotwired/stimulus"
import mapboxgl from 'mapbox-gl'
// import MapboxGeocoder from "@mapbox/mapbox-gl-geocoder"

// Connects to data-controller="map"
export default class extends Controller {
  static values = {
    apiKey: String,
    markers: Array,
  }

  static targets = ["details"]

  connect() {
    mapboxgl.accessToken = this.apiKeyValue

    this.map = new mapboxgl.Map({
      container: this.element,
      // style: "mapbox://styles/mapbox/dark-v11"
      style: "mapbox://styles/raecine/clt9tholt007801r5des95bas"

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
      const el = document.createElement('div');
      el.className = 'custom-markers';

      let iconClass;

      if (marker.checkin_count > 40) {
        iconClass = 'marker-high';
      } else if (marker.checkin_count > 20) {
        iconClass= 'marker-medium';
      } else {
        iconClass = 'marker-low';
      }

      // if (marker.category === 'club') {
      //   el.innerHTML = '<i class="fa-solid fa-champagne-glasses" style="font-size: 28px;"></i>';
      // } else if (marker.category === 'sports') {
      //   el.innerHTML = '<i class="fa-solid fa-person-running" style="font-size: 28px;"></i>';
      // } else if (marker.category === 'meetup') {
      //   el.innerHTML = '<i class="fa-solid fa-users" style="font-size: 28px;"></i>';
      // } else if (marker.category === 'tech') {
      //   el.innerHTML = '<i class="fa-solid fa-robot" style="font-size: 28px;"></i>';
      // }

      const iconHTML = {
        'club': '<i class="fa-solid fa-champagne-glasses"></i>',
        'sports': '<i class="fa-solid fa-person-running"></i>',
        'meetup': '<i class="fa-solid fa-users"></i>',
        'tech': '<i class="fa-solid fa-robot"></i>',
      }[marker.category];

      if (iconHTML) {
        el.innerHTML = iconHTML;
        el.firstChild.className += ` ${iconClass}`; // Add class to the <i> element
      }

      console.log("cat", marker.category);
      const popup = new mapboxgl.Popup().setHTML(marker.info_window_html)

      el.id = `marker_${marker.id}`;

      const markerObj = new mapboxgl.Marker(el)
        .setLngLat([ marker.lng, marker.lat ])
        // .setPopup(popup)
        .addTo(this.map)
      console.log(marker)

      const markerElemt = markerObj.getElement();
      markerElemt.addEventListener("click", () => {
        this.detailsTarget.innerHTML = marker.info_window_html
        this.detailsTarget.querySelector(".btn-close").addEventListener("click", () => {
          this.detailsTarget.innerHTML = ""
        })
      })

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


      // const current_x = 139.7139662
      // const current_y = 35.6449777

      this.markersValue.forEach((marker) => {

      const event_x = marker.lng
      const event_y = marker.lat
      const event_id = marker.id;

      const coordinates = `${current_x},${current_y};${event_x},${event_y}`
      const distance = this.getDistance(coordinates);


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

}
