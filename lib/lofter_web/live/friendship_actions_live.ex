defmodule LofterWeb.FriendshipActionsLive do
  use Phoenix.LiveComponent
  use PetalComponents
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
      Lofter.Friendships.unfriend_friendship(
        %User{
          id: socket.assigns.current_user.id
        },
        %User{id: friend_id}
      )

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

  def badge_date(date) do
    Calendar.strftime(date, "%d %B %Y")

  end

  def render(assigns) do
    ~H"""
    <div>
      <%= if @friendship do %>
        <div class="mb-2">
          <%= case @friendship.status do %>
            <% :pending -> %>
            <.badge color="warning" label={"Pending since " <> badge_date(@friendship.updated_at)} />
            <% :confirmed -> %>
              <.badge color="success" label={"Friends since " <> badge_date(@friendship.updated_at)}/>
            <% _ -> %> 
          <% end %>
        </div>
      <% end %>
      <%= if @friendship && @friendship.last_actioned_by == @current_user.id do %>
        <%= case @friendship.status do %>
          <% :pending -> %>
            <.button icon link_type="a" color="danger" to="#" phx-target={@myself} phx-click="remove" phx-value-friend-id={@user_two.id} >
              <Heroicons.Solid.user_remove class="w-5 h-5" />
              Undo friend request
            </.button>
          <% :confirmed -> %>
            <.button icon link_type="a" color="danger" to="#" phx-target={@myself} phx-click="remove" phx-value-friend-id={@user_two.id} >
              <Heroicons.Solid.user_remove class="w-5 h-5" />
              Remove from friends
            </.button>
          <% _ -> %>
            <.button icon link_type="a" color="success" to="#" phx-target={@myself} phx-click="request" phx-value-friend-id={@user_two.id} >
              <Heroicons.Solid.user_add class="w-5 h-5" />
              Add as a friend
            </.button>
        <% end %>
      <% end %>
      <%= if @friendship && @friendship.last_actioned_by != @current_user.id do %>
        <%= case @friendship.status do %>
          <% :pending -> %>
          <div class="flex flex-wrap space-x-2">
            <.button icon link_type="button" color="success" phx-target={@myself} phx-click="accept" phx-value-friend-id={@user_two.id}>
              <Heroicons.Solid.user_add class="w-5 h-5" />
              Accept friend request
            </.button>
            <.button icon link_type="button" color="danger" phx-target={@myself} phx-click="remove" phx-value-friend-id={@user_two.id}>
              <Heroicons.Solid.user_remove class="w-5 h-5" />
              Reject
            </.button>
            </div>
          <% :confirmed -> %>
            <.button icon link_type="button" color="danger" phx-target={@myself} phx-click="remove" phx-value-friend-id={@user_two.id}>
              <Heroicons.Solid.user_remove class="w-5 h-5" />
              Remove from friends
            </.button>
          <% _ -> %>
            <.button icon link_type="button" color="success" phx-target={@myself} phx-click="request" phx-value-friend-id={@user_two.id}>
              Add as a friend
            </.button>
        <% end %>
      <% end %>
      <%= if @friendship == nil do %>
        <.button icon link_type="button" color="success" phx-target={@myself} phx-click="request" phx-value-friend-id={@user_two.id}>
          <Heroicons.Solid.user_add class="w-5 h-5" />
          Add as a friend
        </.button>
      <% end %>
    </div>
    """
  end
end
