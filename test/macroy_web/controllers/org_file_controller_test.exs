defmodule  MacroyWeb.OrgFileControllerTest do
  use MacroyWeb.ConnCase
  alias Macroy.{User, OrgFile, Repo}

  @blorp_org %{
    host: "localhost",
    path: "/home/blorp",
    filename: "crime.org"
  }

  @css_org %{
    host: "localhost",
    path: "/home/css",
    filename: "communism.org"
  }

  @valid_user %{
    email: "kilroy@crimsonstarsoftware.org",
    password: "I'm in love with my own reflection. I can dance forever."
  }

  setup_all do
    # Explicitly get a connection before each test
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Macroy.Repo)
    {:ok, user} = Repo.insert(User.changeset(%User{}, @valid_user))
    conn = Plug.Test.init_test_session(build_conn(), current_user_id: user.id)

    {:ok, %{conn: conn, user: user}}
  end

  setup do
    Repo.insert(OrgFile.changeset(%OrgFile{}, @blorp_org))
    Repo.insert(OrgFile.changeset(%OrgFile{}, @css_org))
    :ok
  end

  describe "index/2" do
    test "all files load", %{conn: conn, user: user} do
      # Page doesn't explode in flames when logged in
      resp = conn
      |> assign(:current_user, user)
      |> get("/orgfiles")
      |> html_response(200)

      # Assert that each orgfile shows up 
      assert resp =~ @blorp_org.path
      assert resp =~ @css_org.path
    end

    test "redirects to login if not logged in", %{conn: conn} do
      assert "/login" = redirected_to(get(conn, "/orgfiles"), 302)
    end
  end
end
