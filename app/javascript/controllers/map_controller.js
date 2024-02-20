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
    this.#addHeatmapLayer()

    this.map.addControl(new MapboxGeocoder({ accessToken: mapboxgl.accessToken, mapboxgl: mapboxgl }))
  }

  #addMarkersToMap() {
    this.markersValue.forEach((marker) => {
      const popup = new mapboxgl.Popup().setHTML(marker.info_window_html)
      new mapboxgl.Marker()
        .setLngLat([ marker.lng, marker.lat ])
        .setPopup(popup)
        .addTo(this.map)
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


    new mapboxgl.Marker(el)
    .setLngLat([ longitude, latitude ])
    .addTo(this.map)

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

  #addHeatmapLayer() {

    this.map.addLayer({
      id: 'heatmap-layer',
      type: 'heatmap',
      source: {
        type: 'geojson',
        data: 'trees.geojson',
      },
      paint: {
        'heatmap-weight': {
          property: 'dbh',
          type: 'exponential',
          stops: [
            [1, 0],
            [62, 1],
          ],
        },
        'heatmap-intensity': 1.5,
        'heatmap-color': [
          'interpolate',
          ['linear'],
          ['heatmap-density'],
          0, 'rgba(0,0,255,0)',
          0.1, 'royalblue',
          0.3, 'cyan',
          0.5, 'lime',
          0.7, 'yellow',
          1, 'red',
        ],
        'heatmap-radius': 25,
      },
    });
  }

  // map.on('load', () => {
  //   map.addSource('trees', {
  //     type: 'geojson',
  //     data: 'app/javascript/trees.geojson'
  //   });

  //   map.addLayer(
  //     {
  //       id: 'trees-heat',
  //       type: 'heatmap',
  //       source: 'trees',
  //       maxzoom: 15,
  //       paint: {
  //         // increase weight as diameter breast height increases
  //         'heatmap-weight': {
  //           property: 'dbh',
  //           type: 'exponential',
  //           stops: [
  //             [1, 0],
  //             [62, 1]
  //           ]
  //         },
  //         // increase intensity as zoom level increases
  //         'heatmap-intensity': {
  //           stops: [
  //             [11, 1],
  //             [15, 3]
  //           ]
  //         },
  //         // assign color values be applied to points depending on their density
  //         'heatmap-color': [
  //           'interpolate',
  //           ['linear'],
  //           ['heatmap-density'],
  //           0,
  //           'rgba(236,222,239,0)',
  //           0.2,
  //           'rgb(208,209,230)',
  //           0.4,
  //           'rgb(166,189,219)',
  //           0.6,
  //           'rgb(103,169,207)',
  //           0.8,
  //           'rgb(28,144,153)'
  //         ],
  //         // increase radius as zoom increases
  //         'heatmap-radius': {
  //           stops: [
  //             [11, 15],
  //             [15, 20]
  //           ]
  //         },
  //         // decrease opacity to transition into the circle layer
  //         'heatmap-opacity': {
  //           default: 1,
  //           stops: [
  //             [14, 1],
  //             [15, 0]
  //           ]
  //         }
  //       }
  //     },
  //     'waterway-label'
  //   );

  //   map.addLayer(
  //     {
  //       id: 'trees-point',
  //       type: 'circle',
  //       source: 'trees',
  //       minzoom: 14,
  //       paint: {
  //         // increase the radius of the circle as the zoom level and dbh value increases
  //         'circle-radius': {
  //           property: 'dbh',
  //           type: 'exponential',
  //           stops: [
  //             [{ zoom: 15, value: 1 }, 5],
  //             [{ zoom: 15, value: 62 }, 10],
  //             [{ zoom: 22, value: 1 }, 20],
  //             [{ zoom: 22, value: 62 }, 50]
  //           ]
  //         },
  //         'circle-color': {
  //           property: 'dbh',
  //           type: 'exponential',
  //           stops: [
  //             [0, 'rgba(236,222,239,0)'],
  //             [10, 'rgb(236,222,239)'],
  //             [20, 'rgb(208,209,230)'],
  //             [30, 'rgb(166,189,219)'],
  //             [40, 'rgb(103,169,207)'],
  //             [50, 'rgb(28,144,153)'],
  //             [60, 'rgb(1,108,89)']
  //           ]
  //         },
  //         'circle-stroke-color': 'white',
  //         'circle-stroke-width': 1,
  //         'circle-opacity': {
  //           stops: [
  //             [14, 0],
  //             [15, 1]
  //           ]
  //         }
  //       }
  //     },
  //     'waterway-label'
  //   );
  // });
}
