defmodule LofterWeb.GameSettingsController do
  use LofterWeb, :controller

  def new(conn, _params) do
    render(conn, "new.html")
  end

  def create(conn, %{"game_settings" => %{"course" => course, "holes" => holes}}) do
    redirect(conn, to: "/game/edit")
  end

  def create(conn, _params) do
    conn
    |> assign(:errors, "Fill out your desired settings:")
    |> render("new.html")
  end
end
