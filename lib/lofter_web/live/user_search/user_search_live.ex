defmodule LofterWeb.UserSearchLive do
  @moduledoc """
  LiveView for players searching players
  """

  use Phoenix.LiveView, layout: {LofterWeb.LayoutView, "live.html"}
  use Phoenix.HTML
  use PetalComponents

  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:query, "")
     |> assign(:selected_user, nil)
     |> assign(:results, [])}
  end

  def handle_event("search", %{"search" => %{"query" => ""}}, socket) do
    results = []

    {:noreply,
     socket
     |> assign(:results, results)}
  end

  def handle_event("search", %{"search" => %{"query" => query}}, socket) do
    results = Lofter.Accounts.search_users_with_friendships(query, socket.assigns.current_user.id)

    {:noreply,
     socket
     |> assign(:query, query)
     |> assign(:results, results)}
  end

  def handle_event("clear", _params, socket) do
    {:noreply,
     socket
     |> push_event("toggle-drawer", %{open: false})
     |> assign(:query, "")
     |> assign(:results, [])}
  end

  def handle_event("select_user", %{"user_id" => user_id}, socket) do
    user_with_friendship =
      Lofter.Accounts.get_user_with_friendship!(user_id, socket.assigns.current_user.id)

    {:noreply,
     socket
     |> push_event("toggle-drawer", %{open: true})
     |> assign(:selected_user, user_with_friendship)}
  end
end
