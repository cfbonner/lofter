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
      |> assign(:open, false)
    }
  end

  def handle_event("set_current", %{"hole-id" => hole_id}, socket) do
    new_current = Lofter.Games.get_hole!(hole_id)
    {:noreply, 
      socket
      |> assign(:current, new_current)
      |> assign(:open, true)
    }
  end

  def handle_event("add_another", _value, socket) do
    {:ok, updated} = Lofter.Games.add_hole!(socket.assigns.match)
    match = Lofter.Games.get_match!(socket.assigns.match.id)
    {:noreply, 
      socket
      |> assign(:match, match)
      |> assign(:current, List.last(match.holes))
      |> assign(:open, true)
    }
  end

  def handle_event("next_hole", _value, socket) do
    current_match = socket.assigns.match
    current_hole = socket.assigns.current
    new_current = Lofter.Games.next_hole!(
      current_match.id,
      current_hole.position,
      current_match.length
    )

    {:noreply, assign(socket, :current, new_current)}
  end

  def handle_event("previous_hole", _value, socket) do
    current_match = socket.assigns.match
    current_hole = socket.assigns.current
    new_current = Lofter.Games.prev_hole!(
      current_match.id,
      current_hole.position,
      current_match.length
    )

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

  def handle_event("toggle_drawer", _value, socket) do
    open = !socket.assigns.open
    {:noreply, assign(socket, :open, open)}
  end 
end
