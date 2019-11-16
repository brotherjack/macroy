defmodule MacroyWeb.UserControllerTest do
  use MacroyWeb.ConnCase

  describe "MacroyWeb.UserController.new/2" do
    test "GET /", %{conn: conn} do
      conn = get(conn, "/user/new")
      resp = html_response(conn, 200)
      assert resp =~ "TODO #0: Make a Macroy User Account"
    end
  end
end
