defmodule LofterWeb.HoleEditComponent do
  use Phoenix.LiveComponent
  use Phoenix.HTML
end

defmodule LofterWeb.StrokeOptionComponent do
  use Phoenix.LiveComponent

  def render(assigns) do
    ~L"""
    <label 
      for="hole_strokes_<%= @strokes %>" 
      class="flex items-center leading-none py-2 text-sm font-bold"
    >
      <input 
        type="radio" 
        id="hole_strokes_<%= @strokes %>" 
        name="hole[strokes]" 
        value="<%= @strokes %>" 
        class="mr-2"
        <%= if @current.strokes == @strokes do %>checked=""<% end %>
      >          
      <span><%= humanize_strokes(@strokes) %></span>
    </label>
    """
  end

  defp humanize_strokes(stroke) do
    case stroke do
      1 -> 'Ace (1)'
      2 -> 'Birdie (2)'
      3 -> 'Par (3)'
      4 -> 'Bogey (4)'
      5 -> 'Double Bogey (5)'
      6 -> 'Triple Bogey (6)'
      7 -> 'Quadruple Bogey (7)'
      _ -> stroke
    end
  end

end
