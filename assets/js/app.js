// Credit to Aziz Abdullaev for a tutorial on LiveView & Leaflet
// https://dev.to/azyzz/performance-optimization-when-adding-12000-markers-to-the-map-that-renders-fast-with-elixir-liveview-and-leafletjs-54pf?utm_source=elixir-merge

// Include phoenix_html to handle method=PUT/DELETE in forms and buttons.
import "phoenix_html"
// Establish Phoenix Socket and LiveView configuration.
import {Socket} from "phoenix"
import {LiveSocket} from "phoenix_live_view"
import topbar from "../vendor/topbar"
import L from "../vendor/node_modules/leaflet";

const Map = {
  mounted() {
      const map = L.map("map").setView([37.805885350100986, -122.41594524663745], 14);
      L.tileLayer(
          "https://server.arcgisonline.com/ArcGIS/rest/services/Canvas/World_Light_Gray_Base/MapServer/tile/{z}/{y}/{x}",
          {
              attribution:
                  "Tiles &copy; Esri &mdash; Esri, DeLorme, NAVTEQ",
              maxZoom: 16,
          }
      ).addTo(map);

      let myRenderer = L.canvas({ padding: 0.5 });
      this.handleEvent("add_facility", (facility) => {
        let marker = L.circleMarker(
          [facility.latitude, facility.longitude],
          {
              renderer: myRenderer,
              radius: 1,
              width: 2,
              color: "#ef4444",
              fillColor: "#ef4444",
              fillOpacity: 0.8,
              fill: true,
          }
        );
        marker.addTo(map);
        marker.bindPopup(`<h1>${facility.name}</h1><p><b>Address:</b> ${facility.address}<br/><b>Type:</b> ${facility.type}</p>`);
    });

    this.handleEvent("recenter", ({lon: lon, lat: lat}) => {
      map.setView([lat, lon], 14)
    });
  },
};

const Hooks = {
  Map,
};



let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content")
let liveSocket = new LiveSocket("/live", Socket, {
  longPollFallbackMs: 2500,
  params: {_csrf_token: csrfToken},
  hooks: Hooks
})

// Show progress bar on live navigation and form submits
topbar.config({barColors: {0: "#29d"}, shadowColor: "rgba(0, 0, 0, .3)"})
window.addEventListener("phx:page-loading-start", _info => topbar.show(300))
window.addEventListener("phx:page-loading-stop", _info => topbar.hide())

// connect if there are any LiveViews on the page
liveSocket.connect()

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)  // enabled for duration of browser session
// >> liveSocket.disableLatencySim()
window.liveSocket = liveSocket



