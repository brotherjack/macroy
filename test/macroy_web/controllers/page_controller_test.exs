defmodule MacroyWeb.PageControllerTest do
  use MacroyWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "Welcome to Macroy!"
  end
end
