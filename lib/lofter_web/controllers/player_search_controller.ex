defmodule LofterWeb.PlayerSearchController do
  import Phoenix.LiveView.Controller

  use LofterWeb, :controller

  def action(conn, _) do
    args = [conn, conn.params, conn.assigns.current_user]
    apply(__MODULE__, action_name(conn), args)
  end

  def edit(conn, _params, current_user) do

    live_render(conn, LofterWeb.PlayerSearchLive,
      session: %{
        "user" => current_user
      }
    )
  end
end
