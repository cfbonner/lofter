defmodule LofterWeb.GameController do
  import Phoenix.LiveView.Controller

  use LofterWeb, :controller
  alias Lofter.Games

  def new(conn, _params) do
    changeset = Games.setup_match(%Games.Match{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"match" => match_params}) do
    case Games.start_match(match_params) do
      {:ok, match} ->
        redirect(conn, to: Routes.game_path(conn, :edit, match))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def edit(conn, %{"id" => id}) do
    live_render(conn, LofterWeb.GameLive,
      session: %{
        "game_id" => id
      }
    )
  end
end
