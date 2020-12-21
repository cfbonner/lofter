defmodule LofterWeb.GameController do
  use LofterWeb, :controller

  def edit(conn, _params) do
    render(conn, "edit.html")
  end
end
