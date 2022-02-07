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

  def render(assigns) do
    ~H"""
    <h2><%= @user.email %></h2>

    <ul>
      <%= live_component FriendshipActionsLive, current_user: @current_user, user_two: @user, friendship: @friendship, id: "friendship_actions" %>
    </ul>

    <hr class="block my-4"/>

    <%= link "Start game", to: LofterWeb.Router.Helpers.game_path(@socket, :new, match: %{player_ids: [@user.id]}), class: "button button-primary my-4" %>

    <h3>You and <%= @user.email %></h3>

    <div class="flex space-x-2">
      <div class="relative w-18 h-1">
        <span role="crown" class="absolute top-1 w-full h-1 bg-yellow-300"></span>
        <i role="circle" class="block rounded-full bg-gray-200 w-12 h-12"></i>
      </div>
      <i role="circle" class="block rounded-full bg-gray-200 w-12 h-12"></i>
    </div>

    <%= if Enum.any?(@matches) do %>
      <p class="font-light mb-2">Your <%= Kernel.length(@matches) %> <%= Inflex.inflect("game", Kernel.length(@matches)) %> together:</p>
    <% end %>

    <%= for match <- @matches do %>
      <%= link to: LofterWeb.Router.Helpers.game_path(@socket, :edit, match), 
        class: "block w-full px-2 py-1 mb-2 rounded bg-gray-100 border border-gray-200 hover:border-gray-300" do %>
        <p class="font-bold"><%= Calendar.strftime(match.inserted_at, "%d %B %Y (%p)") %></p>
        <p class="font-light">Last updated <%= Timex.from_now(match.updated_at) %></p>
      <% end %>
    <% end %>
    """
  end
end
