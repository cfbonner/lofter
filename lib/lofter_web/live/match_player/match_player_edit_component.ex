defmodule LofterWeb.MatchPlayerEditComponent do
  use Phoenix.LiveComponent

  def handle_event("update_name", %{"value" => name}, socket) do
    match_player = socket.assigns.match_player
    Lofter.Games.update_match_player(match_player, %{name: name})

    Phoenix.PubSub.broadcast(
      Lofter.PubSub,
      match_topic(socket),
      {:update_match, %{match_id: socket.assigns.match_id}}
    )

    {:noreply, socket}
  end

  defp match_topic(socket) do
    "match:" <> to_string(socket.assigns.match_id)
  end
end
