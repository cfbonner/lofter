defmodule LofterWeb.UserFriendsLive.Show do
  @moduledoc """
  LiveView for players interacting with others
  """
  use Phoenix.LiveView, layout: {LofterWeb.LayoutView, "live.html"}

  use Phoenix.HTML
  alias Lofter.Accounts.User
  alias LofterWeb.FriendshipActionsLive

  def mount(%{"id" => id}, _sec, socket) do
    current_user = socket.assigns.current_user
    user = Lofter.Accounts.get_user_with_friendship!(id, socket.assigns.current_user.id)
    friendship = user.friendship || %Lofter.Friendships.Friendship{}
    matches = Lofter.Games.list_users_matches(current_user, user)

    {:ok,
     socket
     |> assign(:user, user)
     |> assign(:friendship, friendship)
     |> assign(:matches, matches)}
  end

  def handle_event("request_friendship", %{"friend-id" => friend_id}, socket) do
    friend_id = String.to_integer(friend_id)

    {:ok, friendship} =
      Lofter.Friendships.request_friendship(%User{id: socket.assigns.current_user.id}, %User{
        id: friend_id
      })

    {:noreply,
     socket
     |> assign(:friendship, friendship)}
  end

  def handle_event("accept_friendship", %{"id" => user_id}, socket) do
    {:ok, friendship} =
      Lofter.Friendships.confirm_friendship(%User{id: String.to_integer(user_id)}, %User{
        id: socket.assigns.current_user.id
      })

    {:noreply,
     socket
     |> assign(:friendship, friendship)}
  end

  def handle_info({:remove_friend, %{friendship_id: user_id}}, socket) do
    updated_friend_requests =
      socket.assigns.friend_requests
      |> Enum.reject(&(&1.friendship.id == user_id))

    {:noreply,
     socket
     |> assign(:friend_requests, updated_friend_requests)}
  end

  def render(assigns) do
    ~H"""
    <h2><%= @user.email %></h2>

    <ul>
      <%= live_component FriendshipActionsLive, current_user: @current_user, user_two: @user, friendship: @friendship, id: "friendship_actions" %>
    </ul>

    <table>
      <tr>
        <td>Games played</td>
        <td>Personal best</td>
      </tr>
      <tr>
        <td>TODO: 12</td>
        <td>TODO: -1</td>
      </tr>
    </table>

    <hr class="block my-4"/>

    <%= link "Start game", to: LofterWeb.Router.Helpers.game_path(@socket, :new, friend: "id"), class: "button button-primary" %>

    <h3>You and <%= @user.email %></h3>

    <div class="flex space-x-2">
      <div class="relative w-18 h-1">
        <span role="crown" class="absolute top-1 w-full h-1 bg-yellow-300"></span>
        <i role="circle" class="block rounded-full bg-gray-200 w-12 h-12"></i>
      </div>
      <i role="circle" class="block rounded-full bg-gray-200 w-12 h-12"></i>
    </div>

    <h2 class="my-2">Your games</h2>

    <table>
      <tr>
        <td>Games together</td>
      </tr>
      <tr>
        <td><%= Kernel.length(@matches) %></td>
      </tr>
    </table>

    <%= for match <- @matches do %>
      <%= link to: LofterWeb.Router.Helpers.game_path(@socket, :edit, match), 
        class: "block w-full px-2 py-1 mb-2 rounded bg-gray-100 border border-gray-200 hover:border-gray-300" do %>
        <p class="font-bold"><%= Calendar.strftime(match.inserted_at, "%d %B %Y (%p)") %></p>
        <p>Last updated <%= Timex.from_now(match.updated_at) %></p>
      <% end %>
    <% end %>
    """
  end
end
