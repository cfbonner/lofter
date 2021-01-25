defmodule LofterWeb.ClubhouseController do

  use LofterWeb, :controller
  alias Lofter.Clubhouse

  def index(conn, _, user) do
    games = Clubhouse.all_user_matches(user)
    render(conn, "index.html", games: games, user: user)
  end

  def action(conn, _) do
    args = [conn, conn.params, conn.assigns.current_user]
    apply(__MODULE__, action_name(conn), args)
  end
end
