defmodule LofterWeb.UserFriendsLive.Index do
  use Phoenix.LiveView, layout: {LofterWeb.LayoutView, "live.html"}
  use Phoenix.HTML

  alias Lofter.Accounts.User
  alias Lofter.Friendships
  alias LofterWeb.Router.Helpers, as: Routes
  alias LofterWeb.FriendshipActionsLive

  @topic "users_friend_requests:"

  def mount(
        _params,
        _session,
        socket = %{assigns: %{current_user: current_user}}
      ) do
    Phoenix.PubSub.subscribe(Lofter.PubSub, @topic <> "#{socket.assigns.current_user.id}")
    friends = Lofter.Friendships.get_users_friends(socket.assigns.current_user)
    friend_requests = Lofter.Friendships.get_users_friends(socket.assigns.current_user, :pending)

    {:ok,
     socket
     |> assign(:friends, friends)
     |> assign(:friend_requests, friend_requests)}
  end

  def handle_info({:new_friend, %{user_id: user_id}}, socket) do
    new_friend_request =
      Lofter.Friendships.get_users_friend(
        %User{id: socket.assigns.current_user.id},
        %User{id: user_id},
        :pending
      )

    {:noreply,
     socket
     |> assign(:friend_requests, [new_friend_request | socket.assigns.friend_requests])}
  end

  def handle_info({:remove_friend, %{friendship_id: user_id}}, socket) do
    updated_friend_requests =
      socket.assigns.friend_requests
      |> Enum.reject(&(&1.friendship.id == user_id))

    {:noreply,
     socket
     |> assign(:friend_requests, updated_friend_requests)}
  end

  def handle_event("accept", %{"id" => user_id}, socket) do
    friendship =
      Friendships.confirm_friendship(%User{id: user_id}, %User{id: socket.assigns.current_user.id})

    new_friendship =
      Lofter.Friendships.get_users_friend(
        %User{id: socket.assigns.current_user.id},
        %User{id: user_id},
        :confirmed
      )

    {:noreply,
     socket
     |> assign(:friends, [new_friendship | socket.assigns.friends])
     |> assign(
       :friend_requests,
       socket.assigns.friend_requests |> Enum.reject(&(&1.id == new_friendship.id))
     )}
  end

  def handle_event("remove", %{"id" => id}, socket) do
    Friendships.unfriend_friendship(%User{id: id}, %User{id: socket.assigns.current_user.id})

    {:noreply,
     socket
     |> assign(
       :friends,
       Enum.filter(socket.assigns.friends, &(&1.id == id))
     )}
  end

  def handle_event("reject", %{"id" => id}, socket) do
    Friendships.reject_friendship(%User{id: id}, %User{id: socket.assigns.current_user.id})

    {:noreply, socket}
  end

  def render(assigns) do
    ~H"""
    <h2 class="mb-4">Friend requests</h2>
    <%= for request <- @friend_requests do %>
      <div class="w-full flex justify-between items-center w-full px-2 py-1 mb-2 rounded bg-gray-100 border border-gray-200">
        <%= link to: Routes.user_friends_show_path(@socket, :show, request), class: "py-2 align-right" do %>
          <%= request.email %>
        <% end %>
        <div class="text-right">
          <%= live_component FriendshipActionsLive, current_user: @current_user, user_two: request, friendship: request.friendship, id: "friendship_request_actions_" <> Integer.to_string(request.id) %>
        </div>
      </div>
    <% end %>

    <h2 class="mb-4">Friends</h2>
    <%= for friend <- @friends do %>
      <div class="w-full flex justify-between items-center w-full px-2 py-1 mb-2 rounded bg-gray-100 border border-gray-200">
        <%= link to: Routes.user_friends_show_path(@socket, :show, friend), class: "py-2 align-right" do %>
          <%= friend.email %>
        <% end %>
        <div class="text-right">
          <%= live_component FriendshipActionsLive, current_user: @current_user, user_two: friend, friendship: friend.friendship, id: "friendship_actions" <> Integer.to_string(friend.id) %>
        </div>
      </div>
    <% end %>
    """
  end
end
