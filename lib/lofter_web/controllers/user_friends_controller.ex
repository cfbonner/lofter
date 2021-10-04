defmodule LofterWeb.UserFriendsController do
  import Phoenix.LiveView.Controller

  use LofterWeb, :controller

  def action(conn, _) do
    args = [conn, conn.params, conn.assigns.current_user]
    apply(__MODULE__, action_name(conn), args)
  end

  def index(conn, _params, current_user) do
    friends = Lofter.Friendships.get_users_friends(current_user)
    friend_requests = Lofter.Friendships.get_users_friends(current_user, :pending)
    live_render(conn, LofterWeb.UserFriendsLive, 
      session: %{ 
        "user" => current_user, "friends" => friends, "friend_requests" => friend_requests
      }
    )
  end
end
