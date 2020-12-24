defmodule LofterWeb.GameLive do
  @moduledoc """
  LiveView for updating Hole strokes within a Match
  """

  use Phoenix.LiveView

  def mount(_params, %{"game_id" => match_id}, socket) do
    match = Lofter.Games.get_match!(match_id)
    [current | _rest] = match.holes
    {:ok, socket 
      |> assign(:match, match) 
      |> assign(:current, current)
    }
  end

  def handle_event("set_current", %{"hole-id" => hole_id}, socket) do
    new_current = Lofter.Games.get_hole!(hole_id)
    {:noreply, assign(socket, :current, new_current)}
  end

  def handle_event(
        "update_hole", 
        %{"hole" => %{"strokes" => strokes}}, 
        socket
      ) do
    updated_match = Lofter.Games.update_match(socket.assigns.match.id, socket.assigns.current.id, strokes)
    updated_current = Lofter.Games.get_hole!(socket.assigns.current.id)
    {
      :noreply, 
      socket 
       |> assign(:match, updated_match) 
       |> assign(:current, updated_current)
    }
  end

  def handle_event(
        "update_hole", 
        %{"clear" => "true"}, 
        socket
      ) do
    updated_match = Lofter.Games.update_match(socket.assigns.match.id, socket.assigns.current.id, 0)
    updated_current = Lofter.Games.get_hole!(socket.assigns.current.id)
    {
      :noreply, 
      socket 
       |> assign(:match, updated_match) 
       |> assign(:current, updated_current)
    }
  end
end
