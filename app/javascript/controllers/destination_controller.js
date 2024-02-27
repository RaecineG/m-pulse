import { Controller } from "@hotwired/stimulus"
import mapboxgl from 'mapbox-gl'

// Connects to data-controller="destination"
export default class extends Controller {
  static values = {
    apiKey: String,
    marker: Object
  }

  connect() {
    mapboxgl.accessToken = this.apiKeyValue

    this.map = new mapboxgl.Map({
      container: this.element,
      style: "mapbox://styles/mapbox/dark-v11"
    })

    this.#addMarkerToMap()
    this.#fitMapToDirections()
    this.#getDestinationRoute()
  }

  #addMarkerToMap() {
    new mapboxgl.Marker()
      .setLngLat([ this.markerValue.lng, this.markerValue.lat ])
      .addTo(this.map)
  }

  #fitMapToDirections() {
    const bounds = new mapboxgl.LngLatBounds()
    bounds.extend([ this.markerValue.lng, this.markerValue.lat ])
    this.map.fitBounds(bounds, { padding: 100, maxZoom: 15, duration: 0 })
  }

  #getDestinationRoute() {
    const direction = new MapboxDirections({
      accessToken: mapboxgl.accessToken,
      routePadding: 50,
      profile: "mapbox/driving",
      controls: {
        inputs: false,
        instructions: true
      }
    })

    this.map.addControl(
      direction,
      'top-left'
    )

    direction.setOrigin([139.70818573877403, 35.634212708976946])

    // if ("geolocation" in navigator) {
    //   // Get the current position
    //   const current = navigator.geolocation.getCurrentPosition(
    //     this.handleSuccess.bind(this),
    //     this.handleError.bind(this)
    //   );
    // } else {
    //   // Geolocation is not supported by this browser
    //   console.log("Geolocation is not supported by this browser.");
    // }


    setTimeout(() => {
      direction.setDestination([ this.markerValue.lng, this.markerValue.lat ])
    }, 1000);
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

  //https://api.mapbox.com/directions/v5/mapbox/driving/{coordinates}

  // Origin is Impact Hub, Tokyo 👇
  // 35.634212708976946, 139.70818573877403


  // geolocation stuff
  // #getDestinationRoute() {
  //   navigator.geolocation.getCurrentPosition((position) => {
  //     // direction.setOrigin([position.coords.longitude, position.coords.latitude])
  //     direction.setOrigin([139.70821271359765, 35.63392637229652])
  //     console.log([position.coords.longitude, position.coords.latitude])
  //     direction.setDestination("Tokyo Tower Official Shop Galaxy, 芝公園4-2-8, 東京都, Tokyo Prefecture 105-0011, Japan")
  //   });
  // }

  // let direction;

  // const renderDirection = (showInstructions = false) => {
  //   // Part for the destination
  //   if (direction) {
  //     map.removeControl(direction)
  //   }
  //   direction = new MapboxDirections({
  //       accessToken: mapboxgl.accessToken,
  //       routePadding: 50,
  //       controls: {
  //         inputs: false,
  //         instructions: showInstructions
  //       }
  //     })
  //   map.addControl(
  //     direction,
  //     'top-left'
  //   );
  //   if (navigator.geolocation) {
  //     navigator.geolocation.getCurrentPosition((position) => {
  //       // direction.setOrigin([position.coords.longitude, position.coords.latitude])
  //       direction.setOrigin([139.70821271359765, 35.63392637229652])
  //       console.log([position.coords.longitude, position.coords.latitude])
  //       direction.setDestination("Tokyo Tower Official Shop Galaxy, 芝公園4-2-8, 東京都, Tokyo Prefecture 105-0011, Japan")
  //     });
  //   }
  // }
}
