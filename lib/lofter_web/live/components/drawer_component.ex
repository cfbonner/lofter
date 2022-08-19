defmodule LofterWeb.DrawerComponent do
  use Phoenix.LiveComponent
  use Phoenix.HTML
  use PetalComponents

  def render(assigns) do
    ~H"""
    <div 
      x-data="{ open: false }"
      x-cloak="true"
      x-on:toggle-drawer="open = $event.detail.state"
      class="drawer closed dark:bg-gray-600"
      x-bind:class="{'drawer': open == true, 'drawer closed': open == false}"
      phx-hook="DrawerToggle"
    >
      <button 
        @click="open = ! open"
        @keydown.escape.window="open = false"
        class="drawer-handle"
    >
      <Heroicons.Solid.menu_alt_4 class="w-4 h-4 ml-1 -mr-1 text-gray-800 dark:text-gray-100" />
      <span class="sr-only">Toggle</span>
      </button>
      <div class="drawer-contents max-w-xl mx-auto">
        <%= render_block(@inner_block, assigns) %>
      </div>
    </div>
    """
  end
end
