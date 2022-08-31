defmodule LofterWeb.ClubhouseController do
  use LofterWeb, :controller
  alias Lofter.Games
  alias Lofter.Friendships

  def index(conn, _, user) do
    games = Games.list_users_matches(user)
    friends = Friendships.get_users_friends(user)
    pending_friends = Friendships.get_users_friends(user, :pending)
    render(conn, "index.html", friends: friends, pending_friends: pending_friends, games: games, user: user)
  end

  def action(conn, _) do
    args = [conn, conn.params, conn.assigns.current_user]
    apply(__MODULE__, action_name(conn), args)
  end
end
