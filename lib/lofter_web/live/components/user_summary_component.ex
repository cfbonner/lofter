defmodule LofterWeb.UserSummaryComponent do
  use Phoenix.LiveComponent
  use Phoenix.HTML
  alias LofterWeb.Router.Helpers, as: Routes
  alias LofterWeb.FriendshipActionsLive

  def render(assigns) do
    ~H"""
    <div>
      <%= if @selected_user != nil do %>
        <%= link to: Routes.user_friends_show_path(@socket, :show, @selected_user), class: "py-2" do %>
          <h2><%= @selected_user.email %></h2>
        <% end %>
        <p>Account created <%= Timex.from_now(@selected_user.inserted_at) %></p>
        <div class="text-right">
          <%= live_component FriendshipActionsLive, current_user: @current_user, user_two: @selected_user, friendship: @selected_user.friendship, id: "friendship_actions" %>
        </div>
        <%= if @selected_user.friendship && @selected_user.friendship.status == :confirmed do %>
          <button class="mt-4 button button-primary">New game</button>
        <% end %>
        <hr class="my-4"/>
        <%= link to: Routes.user_friends_show_path(@socket, :show, @selected_user), class: "py-2 align-right" do %>
          View profile
        <% end %>
      <% end %>
    </div>
    """
  end
end
