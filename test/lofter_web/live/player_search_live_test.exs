defmodule LofterWeb.PlayerSearchLiveTest do
  use LofterWeb.ConnCase

  import Phoenix.LiveViewTest

  setup :register_and_log_in_user

  test "disconnected and connected render", %{conn: conn} do
    {:ok, _page_live, disconnected_html} = live(conn, "/user/search")
    assert disconnected_html =~ "User search"
  end
end
