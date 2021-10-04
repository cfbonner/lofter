defmodule LofterWeb.PlayerSearchLive do
  @moduledoc """
  LiveView for players searching players
  """

  use Phoenix.LiveView
  use Phoenix.HTML

  alias Lofter.Accounts.User

  def mount(_params, %{"user" => user}, socket) do
    {:ok,
     socket
     |> assign(:user, user)
     |> assign(:query, "")
     |> assign(:results, [])}
  end

  @doc """
  Handle empty search with no results
  """
  def handle_event("search", %{"search" => %{"query" => ""}}, socket) do
    results = []

    {:noreply,
     socket
     |> assign(:query, "")
     |> assign(:results, results)}
  end

  @doc """
  Handle search with results
  """
  def handle_event("search", %{"search" => %{"query" => query}}, socket) do
    results = Lofter.Accounts.search_users_with_friends(query, socket.assigns.user.id)

    {:noreply,
     socket
     |> assign(:query, query)
     |> assign(:results, results)}
  end

  @doc """
  Clear input and results list
  """
  def handle_event("clear", _params, socket) do
    {:noreply,
     socket
     |> assign(:query, "")
     |> assign(:results, [])}
  end

  @doc """
  Create a friend request
  """
  def handle_event("request_friendship", %{"friend-id" => friend_id}, socket) do
    {id, _} = Integer.parse(friend_id)
    results = Lofter.Friendships.request_friendship(%User{id: socket.assigns.user.id}, %User{id: id})

    {:noreply, socket}
  end
end
