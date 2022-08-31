defmodule LofterWeb.Components.Tile do
  use Phoenix.Component
  import LofterWeb.Components.Helpers
  alias PetalComponents.Heroicons

  def tile(assigns) do
    assigns =
      assigns
      |> assign_new(:class, fn -> "" end)
      |> assign_new(:to, fn -> nil end)
      |> assign_new(:tile_title, fn -> nil end)
      |> assign_new(:tile_body, fn -> nil end)
      |> assign_rest(~w(class to)a)

    ~H"""
    <%= Phoenix.HTML.Link.link [to: @to, class: build_class([
      "block w-full px-2 py-1 mb-2 rounded bg-gray-100 border border-gray-200 hover:border-gray-300 md:px-6 md:py-4",
      @class
    ])] ++ @rest do %>
      <%= if @tile_title, do: render_slot(@tile_title) %>
      <%= if @tile_body, do: render_slot(@tile_body) %>
      <%= render_slot(@inner_block) %>
    <% end %>
    """
  end

  def tile_title(assigns) do
    assigns =
      assigns
      |> assign_new(:class, fn -> "" end)

    ~H"""
    <p 
      class={build_class([
        "flex items-center space-x-4 font-bold",
        @class
      ])}>
        <%= render_slot(@inner_block) %>
      </p>
    """
  end

  def tile_body(assigns) do
    assigns =
      assigns
      |> assign_new(:class, fn -> "" end)

    ~H"""
    <p 
      class={build_class([
        "flex items-center space-x-4",
        @class
      ])}>
        <%= render_slot(@inner_block) %>
      </p>
    """
  end
end
