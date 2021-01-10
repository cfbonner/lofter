defmodule LofterWeb.GameLive do
  @moduledoc """
  LiveView for updating Hole strokes within a Match
  """

  use Phoenix.LiveView

  @topic "match"

  def mount(_params, %{"game_id" => match_id}, socket) do
    Phoenix.PubSub.subscribe(Lofter.PubSub, "#{@topic}:#{match_id}")

    match = Lofter.Games.get_match!(match_id)
    [match_player | _other_players] = match.match_players
    [current | _other_holes] = match_player.holes

    {:ok,
     socket
     |> assign(:match, match)
     |> assign(:match_player, match_player)
     |> assign(:current, current)
     |> assign(:open, false)}
  end

  def handle_event("show_player", %{"match-player-id" => match_player_id}, socket) do
    match_player = Lofter.Games.get_match_player!(socket.assigns.match.match_players, match_player_id)

    {:noreply, assign(socket, :match_player, match_player)}
  end

  def handle_event("set_current", %{"hole-id" => hole_id}, socket) do
    new_current = Lofter.Games.get_hole!(hole_id)

    {:noreply,
     socket
     |> assign(:current, new_current)
     |> assign(:open, true)}
  end

  def handle_event("add_another", _value, socket) do
    {:ok, updated} = Lofter.Games.add_hole!(socket.assigns.match)
    match = Lofter.Games.get_match!(socket.assigns.match.id)

    {:noreply,
     socket
     |> assign(:match, match)
     |> assign(:current, List.last(match.holes))
     |> assign(:open, true)}
  end

  def handle_event("next_hole", _value, socket) do
    current_match = socket.assigns.match
    current_hole = socket.assigns.current

    new_current =
      Lofter.Games.next_hole!(
        current_match.id,
        current_hole.position,
        current_match.length
      )

    {:noreply, assign(socket, :current, new_current)}
  end

  def handle_event("previous_hole", _value, socket) do
    current_match = socket.assigns.match
    current_hole = socket.assigns.current

    new_current =
      Lofter.Games.prev_hole!(
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
    Lofter.Games.update_match(socket.assigns.match.id, socket.assigns.current.id, strokes)

    Phoenix.PubSub.broadcast(
      Lofter.PubSub,
      "#{@topic}:#{socket.assigns.match.id}",
      {:update_match, %{match_id: socket.assigns.match.id}}
    )

    {:noreply, socket}
  end

  def handle_event("toggle_drawer", _value, socket) do
    open = !socket.assigns.open
    {:noreply, assign(socket, :open, open)}
  end

  def handle_info({:update_match, %{match_id: match_id}}, socket) do
    match = Lofter.Games.get_match!(match_id)

    [player | _rest] =
      Enum.filter(match.match_players, fn mp -> mp.id == socket.assigns.match_player.id end)

    current = update_current_hole(player.holes, socket)

    {
      :noreply,
      socket
      |> assign(:match, match)
      |> assign(:match_player, player)
      |> assign(:current, current)
    }
  end

  defp update_current_hole(holes, socket) do
    case Enum.filter(holes, fn h -> h.id == socket.assigns.current.id end) do
      [current | _rest] ->
        current
      [] ->
        socket.assigns.current
    end
  end
end
