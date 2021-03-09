defmodule LofterWeb.PlayerSearchLive do
  @moduledoc """
  LiveView for players searching players
  """

  use Phoenix.LiveView
  use Phoenix.HTML

  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:query, "")
     |> assign(:results, [])}
  end

  def handle_event("search", %{"search" => %{"query" => query}}, socket) do
    results = Lofter.Accounts.search_users(query)

    {:noreply,
     socket
     |> assign(:query, query)
     |> assign(:results, results)}
  end
end
