defmodule MacroyWeb.UserControllerTest do
  use MacroyWeb.ConnCase
  import MacroyWeb.Helpers

  @valid_attrs %{email: "dovakitty@xs4all.nl", password: "FusRoDah=>!"}

  describe "MacroyWeb.UserController.new/2" do
    test "GET /", %{conn: conn} do
      conn = get(conn, "/user/new")
      resp = html_response(conn, 200)
      assert resp =~ "TODO #0: Make a Macroy User Account"
    end
  end

  describe "MacroyWeb.UserController.create/2" do
    test "user can create an account if they aren't an idiot", %{conn: conn} do
      conn = post(conn, "/user", %{"user" => @valid_attrs})
      assert "/?msg_type=success" = redir_path = redirected_to(conn, 302)
      conn = get(recycle(conn), redir_path)
      assert flash_message_contains(
        conn,
        "success",
        "You have setup a user with email '#{@valid_attrs.email}'."
      )
    end

    test "user cannot create an account without a password", %{conn: conn} do
      conn = post(conn, "/user", %{"user" => Map.take(@valid_attrs, [:email])})
      assert html_response(conn, 200)
      assert flash_message_contains(conn, "danger", "There are errors in your submission.")
    end

    test "user cannot create an account without an email", %{conn: conn} do
      conn = post(conn, "/user", %{"user" => Map.take(@valid_attrs, [:password])})
      assert html_response(conn, 200)
      assert flash_message_contains(conn, "danger", "There are errors in your submission.")
    end

    test "will not allow an invalid email format to be saved", %{conn: conn} do
      invalid_email = "NOPE NOT @ that"
      conn = post(
        conn, "/user", %{"user" => Map.put(@valid_attrs, :email, invalid_email)}
      )
      assert html_response(conn, 200)
      assert flash_message_contains(conn, "danger", "There are errors in your submission.")
      password_err_msg = elem(Keyword.get(conn.assigns.user.errors, :email), 0)
      assert password_err_msg == "has invalid format"
    end
  end
end
