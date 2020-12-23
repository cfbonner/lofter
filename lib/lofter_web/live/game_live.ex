defmodule Lofter.GameLive do
  @moduledoc """
  LiveView for updating Hole strokes within a Match
  """

  use Phoenix.LiveView

  def mount(_params, %{"game_id" => match_id}, socket) do
    match = Lofter.Games.get_match!(match_id)
    {:ok, assign(socket, :match, match)}
  end

  def handle_event("set_score", value, socket) do
    updated_match = Lofter.Games.update_match(socket.assigns.match.id, value["hole-id"], 1)
    {:noreply, assign(socket, :match, updated_match)}
  end
end
