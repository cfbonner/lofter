defmodule LofterWeb.GameControllerTest do
  use LofterWeb.ConnCase, async: true

  setup :register_and_log_in_user

  describe "GET /game/new" do
    test "renders game settings page", %{conn: conn} do
      conn = get(conn, Routes.game_path(conn, :new))
      response = html_response(conn, 200)
      assert response =~ "New game</h1>"
    end

    test "redirects if user is not logged in" do
      conn = build_conn()
      conn = get(conn, Routes.game_path(conn, :new))
      assert redirected_to(conn) == Routes.user_session_path(conn, :new)
    end
  end
end
