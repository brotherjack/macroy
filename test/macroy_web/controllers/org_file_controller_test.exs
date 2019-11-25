defmodule  MacroyWeb.OrgFileControllerTest do
  use MacroyWeb.ConnCase
  alias Macroy.{User, OrgFile, Repo}
  import Ecto.Query

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

  @css_user %{
    email: "kilroy@crimsonstarsoftware.org",
    password: "I'm in love with my own reflection. I can dance forever."
  }

  @blorp_user %{
    email: "daboss@blorp.gorp",
    password: "dahI'mdablorp"
  }

  setup_all do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Macroy.Repo)
    :ok
  end

  setup do
    # Explicitly get a connection before each test
    
    {:ok, user1} = Repo.insert(User.changeset(%User{}, @css_user))
    conn = Plug.Test.init_test_session(build_conn(), current_user_id: user1.id)
    
    {:ok, user2} = Repo.insert(User.changeset(%User{}, @blorp_user))

    user1_params = @css_org
    |> Map.put(:owner_id, user1.id)
    
    user2_params = @blorp_org
    |> Map.put(:owner_id, user2.id)
    
    {:ok, user1_file} = Repo.insert(OrgFile.changeset(%OrgFile{}, user1_params))
    
    {:ok, user2_file} = Repo.insert(OrgFile.changeset(%OrgFile{}, user2_params))
    
    {:ok,
     %{
       conn: conn,
       user: user1,
       my_files: [user1_file],
       their_files: [user2_file]
     }
    }
  end

  describe "index/2" do
    test "all files for current user load", context  do
      # Page doesn't explode in flames when logged in
      resp = context.conn
      |> assign(:current_user, context.user)
      |> get("/orgfiles")
      |> html_response(200)

      # Assert that each orgfile for user shows up...
      for mine <- context.my_files do
        assert resp =~ mine.path
      end

      # ...and no orgfiles from other users
      for not_mine <- context.their_files do
        refute resp =~ not_mine.path
      end
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
    test "logged in user can insert orgfiles", context do
      conn = context.conn
      |> assign(:current_user, context.user)
      |> post("/orgfiles", %{"org_file" => @evil_plans_org})

      query = from f in OrgFile,
        join: u in assoc(f, :owner),
        where: u.id == ^context.user.id and f.filename == ^@evil_plans_org.filename,
        preload: [owner: u]
      evil_plan_in_db = Repo.one(query)
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
