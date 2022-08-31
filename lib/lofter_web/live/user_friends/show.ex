defmodule LofterWeb.UserFriendsLive.Show do
  @moduledoc """
  LiveView for players interacting with others
  """
  use Phoenix.LiveView, layout: {LofterWeb.LayoutView, "live.html"}
  use PetalComponents

  use LofterWeb.Components

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

  defp username(email) do
    String.split(email, "@") |> List.first()
  end

  def render(assigns) do
    ~H"""
    <.h2><%= @user.email %></.h2>

    <ul>
      <%= live_component FriendshipActionsLive, current_user: @current_user, user_two: @user, friendship: @friendship, id: "friendship_actions" %>
    </ul>

    <hr class="block my-4"/>

    <%= if @friendship && @friendship.status == :confirmed do %>
      <%= link "Start game", to: LofterWeb.Router.Helpers.game_path(@socket, :new, match: %{player_ids: [@user.id]}), class: "button button-primary my-4" %>
    <% end %>

    <div class="flex items-center flex-col justify-center">
      <h3 class="font-light mb-2">You & <%= username(@user.email) %></h3>

      <div class="flex space-x-2 mb-4">
        <div class="relative w-10">
          <span role="crown" class="absolute top-2 w-full h-1 bg-yellow-300"></span>
          <i role="circle" class="flex items-center justify-center rounded-full bg-purple-300 w-10 h-10"> <span class="font-light">. .</span></i>
        </div>
        <i role="circle" class="flex items-center justify-center rounded-full bg-gray-200 w-10 h-10"><span class="font-light">. .</span></i>
      </div>
    </div>

    <%= if Enum.any?(@matches) do %>
      <p class="font-light mb-2">Your <%= Kernel.length(@matches) %> <%= Inflex.inflect("game", Kernel.length(@matches)) %> together:</p>
    <% end %>

    <%= for match <- @matches do %>
      <.tile to={LofterWeb.Router.Helpers.game_path(@socket, :edit, match)}>
        <.tile_title>
          <%= Calendar.strftime(match.inserted_at, "%d %B %Y (%p)") %>
        </.tile_title>
        <.tile_body>
          Last updated <%= Timex.from_now(match.updated_at) %>
        </.tile_body>
      </.tile>
    <% end %>
    """
  end
end
