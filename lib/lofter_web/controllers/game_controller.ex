defmodule LofterWeb.GameController do
  import Phoenix.LiveView.Controller

  use LofterWeb, :controller
  alias Lofter.Games

  def action(conn, _) do
    args = [conn, conn.params, conn.assigns.current_user]
    apply(__MODULE__, action_name(conn), args)
  end

  def new(conn, params, user) do
    player_ids =
      case params do
        %{"match" => %{"player_ids" => player_ids}} ->
          Enum.map(player_ids, &String.to_integer/1)

        _ ->
          []
      end

    changeset = Games.setup_match(%Games.Match{player_ids: player_ids}, %{course: "bruntsfield", length: 36})
    users_friends = Lofter.Friendships.get_users_friends(user)
    render(conn, "new.html", changeset: changeset, user: user, users_friends: users_friends)
  end

  def create(conn, %{"match" => match_params}, user) do
    users_match_params = merge_current_user(match_params, user)

    case Games.start_match(users_match_params) do
      {:ok, match} ->
        redirect(conn, to: Routes.game_path(conn, :edit, match))

      {:error, %Ecto.Changeset{} = changeset} ->
        users_friends = Lofter.Friendships.get_users_friends(user)
        render(conn, "new.html", changeset: changeset, user: user, users_friends: users_friends)
    end
  end

  def edit(conn, %{"id" => id}, _user) do
    live_render(conn, LofterWeb.GameLive,
      session: %{
        "game_id" => id
      }
    )
  end

  def index(conn, _, user) do
    render(conn, "index.html", user: user)
  end

  defp merge_current_user(params = %{"player_ids" => player_ids}, user) do
    Map.put(params, "player_ids", [Integer.to_string(user.id) | player_ids])
  end

  defp merge_current_user(params, user) do
    Map.put(params, "player_ids", [Integer.to_string(user.id)])
  end
end
