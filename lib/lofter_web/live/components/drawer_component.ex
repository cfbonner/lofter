defmodule LofterWeb.DrawerComponent do
  use Phoenix.LiveComponent
  use Phoenix.HTML

  def render(assigns) do
    ~H"""
    <div 
      x-data="{ open: false }"
      x-cloak="true"
      x-on:toggle-drawer="open = $event.detail.state"
      class="drawer-closed"
      x-bind:class="{'drawer': open == true, 'drawer closed': open == false}"
      phx-hook="DrawerToggle"
    >
      <button 
        @click="open = !open"
        @keydown.escape.window="open = false"
        class="drawer-handle"
      ><span class="text-sm">Handle</span>
      </button>
      <div class="drawer-contents max-w-xl mx-auto">
        <%= render_block(@inner_block, assigns) %>
      </div>
    </div>
    """
  end
end
