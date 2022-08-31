defmodule LofterWeb.HoleEditComponent do
  use Phoenix.LiveComponent
  use Phoenix.HTML
  use PetalComponents
end

defmodule LofterWeb.StrokeOptionComponent do
  use Phoenix.LiveComponent
  use PetalComponents

  def arrow_undo(assigns \\ %{}) do
    ~H"""
    <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="w-6 h-6">
      <path stroke-linecap="round" stroke-linejoin="round" d="M4.5 12c0-1.232.046-2.453.138-3.662a4.006 4.006 0 013.7-3.7 48.678 48.678 0 017.324 0 4.006 4.006 0 013.7 3.7c.017.22.032.441.046.662M4.5 12l-3-3m3 3l3-3m12 3c0 1.232-.046 2.453-.138 3.662a4.006 4.006 0 01-3.7 3.7 48.657 48.657 0 01-7.324 0 4.006 4.006 0 01-3.7-3.7c-.017-.22-.032-.441-.046-.662M19.5 12l-3 3m3-3l3 3" />
    </svg>
    """
  end

  def render(assigns) do
    ~L"""
      <input 
        type="radio" 
        id="hole_strokes_<%= @strokes %>" 
        name="hole[strokes]" 
        value="<%= @strokes %>" 
        class="sr-only"
        <%= if @current.strokes == @strokes do %>checked=""<% end %>
      >          
      <label 
        for="hole_strokes_<%= @strokes %>" 
        class="w-1/2 sm:w-1/4 flex-auto flex flex-col items-center text-center rounded inline-block px-6 py-2.5 bg-gray-100 border border-gray-200 font-medium text-xs leading-tight uppercase hover:border-gray-300 focus:border-gray-300 focus:outline-none focus:ring-0 active:bg-green-100 <%= if @current.strokes > 0 && @current.strokes == @strokes do %>bg-green-100<% end %>"
      >
    <span class="text-xl"><%= if @strokes != 0, do: @strokes, else: arrow_undo %></span>
      <span class="text-[8px] mt-auto"><%= humanize_strokes(@strokes) %></span>
    </label>
    """
  end

  defp humanize_strokes(stroke) do
    case stroke do
      0 -> 'Reset'
      1 -> 'Ace'
      2 -> 'Birdie'
      3 -> 'Par'
      4 -> 'Bogey'
      5 -> 'Double Bogey'
      6 -> 'Triple Bogey'
      7 -> 'Quadruple Bogey'
      _ -> stroke
    end
  end
end
