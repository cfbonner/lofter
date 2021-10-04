defmodule LofterWeb.UserFriendsLive do
  use Phoenix.LiveView
  use Phoenix.HTML

  alias Lofter.Accounts.User
  alias Lofter.Friendships

  def mount(_params, %{"user" => user, "friends" => friends, "friend_requests" => friend_requests}, socket) do
    {:ok,
     socket
     |> assign(:user, user)
     |> assign(:friends, friends)
     |> assign(:friend_requests, friend_requests)
    }
  end

  @doc """
  Handle friend acceptance
  """
  def handle_event("accept", %{"id" => id}, socket) do
    Friendships.confirm_friendship(%User{id: id}, %User{id: socket.assigns.user.id})

    {:noreply, socket}
  end

  @doc """
  Handle friend deletion
  """
  def handle_event("remove", %{"id" => id}, socket) do
    Friendships.unfriend_friendship(%User{id: id}, %User{id: socket.assigns.user.id})

    {:noreply, socket}
  end
end
