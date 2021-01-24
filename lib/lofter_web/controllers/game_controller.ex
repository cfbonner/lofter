defmodule LofterWeb.GameController do
  import Phoenix.LiveView.Controller

  use LofterWeb, :controller
  alias Lofter.Games

  def action(conn, _) do
    args = [conn, conn.params, conn.assigns.current_user]
    apply(__MODULE__, action_name(conn), args)
  end

  def new(conn, _params, user) do
    changeset = Games.setup_match(%Games.Match{})
    render(conn, "new.html", changeset: changeset, user: user)
  end

  def create(conn, %{"match" => match_params}, user) do
    case Games.start_match(match_params) do
      {:ok, match} ->
        redirect(conn, to: Routes.game_path(conn, :edit, match))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset, user: user)
    end
  end

  def edit(conn, %{"id" => id}, user) do
    live_render(conn, LofterWeb.GameLive,
      session: %{
        "game_id" => id
      }
    )
  end
end
