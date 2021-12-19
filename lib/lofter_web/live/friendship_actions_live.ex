defmodule LofterWeb.FriendshipActionsLive do
  use Phoenix.LiveComponent
  alias Lofter.Accounts.User
  alias Lofter.Friendships

  def handle_event("request", %{"friend-id" => friend_id}, socket) do
    friend_id = String.to_integer(friend_id)

    {:ok, friendship} =
      Friendships.request_friendship(%User{id: socket.assigns.current_user.id}, %User{
        id: friend_id
      })

    {:noreply,
     socket
     |> assign(:friendship, friendship)}
  end

  def handle_event("remove", %{"friend-id" => friend_id}, socket) do
    friend_id = String.to_integer(friend_id)

    {:ok, friendship} =
      Lofter.Friendships.unfriend_friendship(%User{
        id: socket.assigns.current_user.id
      }, %User{id: friend_id})

    {:noreply,
     socket
     |> assign(:friendship, friendship)}
  end

  def handle_event("accept", %{"friend-id" => friend_id}, socket) do
    friend_id = String.to_integer(friend_id)

    {:ok, friendship} =
      Lofter.Friendships.confirm_friendship(%User{id: socket.assigns.current_user.id}, %User{
        id: friend_id
      })

    {:noreply,
     socket
     |> assign(:friendship, friendship)}
  end

  def render(assigns) do
    ~H"""
    <div>
      <%= if @friendship do %>
        <h3><%= inspect @friendship.status %></h3>
      <% end %>
      <%= if @friendship && @friendship.last_actioned_by == @current_user.id do %>
        <%= case @friendship.status do %>
          <% :pending -> %>
            <button phx-target={@myself} phx-click="remove" phx-value-friend-id={@user_two.id} class="text-red-700 hover:underline">
              Undo friend request
            </button>
          <% :confirmed -> %>
            <button phx-target={@myself} phx-click="remove" phx-value-friend-id={@user_two.id} class="text-red-500 hover:underline">
              Remove from friends
            </button>
          <% :unfriended -> %>
            <button phx-target={@myself} phx-click="request" phx-value-friend-id={@user_two.id} class="text-blue-500 hover:underline">
              Add as a friend
            </button>
          <% _ -> %>
            <button phx-target={@myself} phx-click="request" phx-value-friend-id={@user_two.id} class="text-blue-100 hover:underline">
              Add as a friend
            </button>
        <% end %>
      <% end %>
      <%= if @friendship && @friendship.last_actioned_by != @current_user.id do %>
        <%= case @friendship.status do %>
          <% :pending -> %>
            <button phx-target={@myself} phx-click="accept" phx-value-friend-id={@user_two.id} class="text-green-700 hover:underline">
              Accept 
            </button>
            <button phx-target={@myself} phx-click="remove" phx-value-friend-id={@user_two.id} class="text-red-700 hover:underline">
              Reject
            </button>
          <% :confirmed -> %>
            <button phx-target={@myself} phx-click="remove" phx-value-friend-id={@user_two.id} class="text-red-500 hover:underline">
              Remove from friends
            </button>
          <% :unfriended -> %>
            <button phx-target={@myself} phx-click="request" phx-value-friend-id={@user_two.id} class="text-blue-500 hover:underline">
              Add as a friend
            </button>
          <% _ -> %>
            <button phx-target={@myself} phx-click="request" phx-value-friend-id={@user_two.id} class="text-blue-500 hover:underline">
              Add as a friend
            </button>
        <% end %>
      <% end %>
      <%= if @friendship == nil do %>
       <button phx-target={@myself} phx-click="request" phx-value-friend-id={@user_two.id} class="text-blue-500 hover:underline">
         Add as a friend
       </button>
     <% end %>
    </div>
    """
  end
end
