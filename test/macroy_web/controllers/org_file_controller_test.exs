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

  @evil_plans_org %{
    host: "mww.mars.gov",
    path: "/home/evil",
    filename: "bad_things_todo.org"
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
      assert "/login" == redirected_to(get(conn, "/orgfiles"), 302)
    end
  end

  describe "new/2" do
    test "redirects to login if user not logged in", %{conn: conn} do
      assert "/login" = redirected_to(get(conn, "/orgfiles/new"), 302)
    end

    test "auth'd user can view orgfile creation page", %{conn: conn, user: user} do
      resp = conn
      |> assign(:current_user, user)
      |> get("/orgfiles/new")
      |> html_response(200)

      assert resp =~ "New OrgFile"
    end
  end

  describe "create/2" do
    test "logged in user can insert orgfiles", %{conn: conn, user: user} do
      conn = conn
      |> assign(:current_user, user)
      |> post("/orgfiles", %{"org_file" => @evil_plans_org})

      evil_plan_in_db = Repo.get_by(OrgFile, filename: @evil_plans_org.filename)
      show_path = "/orgfiles/#{evil_plan_in_db.id}"

      assert show_path == redirected_to(conn, 302)

      assert evil_plan_in_db.filename == @evil_plans_org.filename
    end

    test "redirects to login if user not logged in", %{conn: conn} do
      params = %{"org_file" => @evil_plans_org}
      assert "/login" == redirected_to(post(conn, "/orgfiles", params), 302)
    end
  end
end
