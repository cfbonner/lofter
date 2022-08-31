defmodule LofterWeb.GameLive do
  @moduledoc """
  LiveView for updating Hole strokes within a Match
  """

  use Phoenix.LiveView
  use PetalComponents
  use LofterWeb.Components

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
     |> assign(:match_player_index, 0)
     |> assign(:current, current)
     |> assign(:open, false)}
  end

  def handle_event("set_current", %{"hole-id" => hole_id}, socket) do
    new_current = Lofter.Games.get_hole!(hole_id)

    {:noreply,
     socket
     |> assign(:current, new_current)
     |> assign(:open, true)}
  end

  def handle_event("add_another", _value, socket) do
    Lofter.Games.add_hole!(socket.assigns.match)

    Phoenix.PubSub.broadcast(
      Lofter.PubSub,
      "#{@topic}:#{socket.assigns.match.id}",
      {:update_match, %{match_id: socket.assigns.match.id}}
    )

    {:noreply, socket}
  end

  def handle_event("set_player", %{"match-player-id" => match_player_id}, socket) do
    match_players = socket.assigns.match.match_players

    [match_player | _rest] =
      Enum.filter(match_players, fn m -> m.id == match_player_id |> String.to_integer() end)

    {
      :noreply,
      socket
      |> assign(:match_player, match_player)
      |> assign(
        :match_player_index,
        Enum.find_index(match_players, fn m -> m == match_player end)
      )
    }
  end

  def handle_event("next_player", _value, socket) do
    match_players = socket.assigns.match.match_players
    new_index = rem(socket.assigns.match_player_index + 1, Enum.count(match_players))

    {
      :noreply,
      socket
      |> assign(:match_player, Enum.at(match_players, new_index))
      |> assign(:match_player_index, new_index)
    }
  end

  def handle_event("previous_player", _value, socket) do
    match_players = socket.assigns.match.match_players
    new_index = rem(socket.assigns.match_player_index - 1, Enum.count(match_players))

    {
      :noreply,
      socket
      |> assign(:match_player, Enum.at(match_players, new_index))
      |> assign(:match_player_index, new_index)
    }
  end

  def handle_event("next_hole", _value, socket) do
    current_match = socket.assigns.match
    current_match_player = socket.assigns.match_player
    current_hole = socket.assigns.current

    new_current =
      Lofter.Games.next_hole!(
        current_match_player.id,
        current_hole.position,
        current_match.length
      )

    {:noreply, assign(socket, :current, new_current)}
  end

  def handle_event("previous_hole", _value, socket) do
    current_match = socket.assigns.match
    current_match_player = socket.assigns.match_player
    current_hole = socket.assigns.current

    new_current =
      Lofter.Games.prev_hole!(
        current_match_player.id,
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
