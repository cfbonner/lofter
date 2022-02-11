import "phoenix_html";
import { Socket } from "phoenix";
import { LiveSocket } from "phoenix_live_view";

let csrfToken = document
  .querySelector("meta[name='csrf-token']")
  .getAttribute("content");

let Hooks = {};
Hooks.holes = {
  updated() {
    if (this.el.dataset.current == "true") {
      window.scroll({
	top: this.el.offsetTop - 8,
	behavior: "smooth",
      });
    }
  },
};

Hooks.DrawerToggle = {
  mounted() {
    this.handleEvent("toggle-drawer", ({open}) => {
      let event = new CustomEvent("toggle-drawer", {
	detail: { state: open }
      })
      this.el.dispatchEvent(event)
    })
  },
};

let liveSocket = new LiveSocket("/live", Socket, {
  params: { _csrf_token: csrfToken },
  hooks: Hooks,
  dom: {
    onBeforeElUpdated(from, to) {
      if (from._x_dataStack) {
        window.Alpine.clone(from, to);
      }
    },
  },
});

liveSocket.connect();

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)
window.liveSocket = liveSocket;

export default liveSocket;
