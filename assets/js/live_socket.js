import "phoenix_html";
import { Socket } from "phoenix";
import { LiveSocket } from "phoenix_live_view";

let csrfToken = document
  .querySelector("meta[name='csrf-token']")
  .getAttribute("content");

let hooks = {};
hooks.holes = {
  updated() {
    const new_current = this.el.querySelector("[data-current=true]");
    window.scroll({
      top: new_current.offsetTop - 8,
      behavior: "smooth",
    });
  },
};

let liveSocket = new LiveSocket("/live", Socket, {
  params: { _csrf_token: csrfToken },
  hooks: hooks,
});

liveSocket.connect();

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)
window.liveSocket = liveSocket;

export default liveSocket;
