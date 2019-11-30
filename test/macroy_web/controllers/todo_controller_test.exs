defmodule MacroyWeb.TodoControllerTest do
  use MacroyWeb.ConnCase
  alias Macroy.{Todo, Repo, User, OrgFile}

  @css_user %{
    email: "kilroy@crimsonstarsoftware.org",
    password: "I'm in love with my own reflection. I can dance forever."
  }

  @blorp_user %{
    email: "daboss@blorp.gorp",
    password: "dahI'mdablorp"
  }

  @css_org %{
    host: "localhost",
    filename: "css_todos.org",
    path: "/home/css/"
  }

  setup_all do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Repo)
    :ok
  end

  setup do
    {:ok, user1} = Repo.insert(User.changeset(%User{}, @css_user))
    conn = Plug.Test.init_test_session(build_conn(), current_user_id: user1.id)

    {:ok, user2} = Repo.insert(User.changeset(%User{}, @blorp_user))

    user1_params = @css_org
    |> Map.put(:owner_id, user1.id)

    {:ok, user1_file} = Repo.insert(OrgFile.changeset(%OrgFile{}, user1_params))
    todo_w_orgfile = %{
      category: "Social",
      closed_on: ~U[2019-08-09 17:43:00Z],
      deadline_on: ~U[2019-08-09 16:00:00Z],
      is_done: true,
      name: "Mandatory Fun Event #420",
      scheduled_for: ~U[2019-08-08 04:00:00Z],
      subcategory: "Party",
      updated_at: ~N[2019-11-28 21:02:02],
      owner_id: user1.id,
      org_file_id: user1_file.id
    }
    todo_wout_orgfile = %{
      category: "Organizational",
      closed_on: ~U[2019-08-09 17:43:00Z],
      deadline_on: ~U[2019-08-09 16:00:00Z],
      is_done: true,
      name: "Take Over the World",
      owner_id: user1.id,
      scheduled_for: ~U[2019-08-08 04:00:00Z],
      subcategory: "Things",
      updated_at: ~N[2019-11-28 21:02:02]
    }
    not_my_todo = %{
      category: "Blorp",
      closed_on: ~U[2019-08-09 17:43:00Z],
      deadline_on: ~U[2019-08-09 16:00:00Z],
      is_done: true,
      name: "Do DORPS",
      owner_id: user2.id,
      scheduled_for: ~U[2019-08-08 04:00:00Z],
      subcategory: "Florp",
      updated_at: ~N[2019-11-28 21:02:02]
    }

    {:ok, todo_1} = Repo.insert(Todo.changeset(%Todo{}, todo_w_orgfile)) 
    {:ok, todo_2} = Repo.insert(Todo.changeset(%Todo{}, todo_wout_orgfile))
    {:ok, not_my_todo} = Repo.insert(Todo.changeset(%Todo{}, not_my_todo))

    {:ok,
     %{
       conn: conn,
       user: user1,
       my_todos: [todo_1, todo_2],
       not_mine: [not_my_todo]
     }
    }
  end

  describe "MacroyWeb.TodoController.index/2" do
    test "all todos for current user show up", context do
      # Page doesn't explode in flames when logged in
      resp = context.conn
      |> assign(:current_user, context.user)
      |> get("/todos")
      |> html_response(200)

      # Assert that each orgfile for user shows up...
      for mine <- context.my_todos do
        assert resp =~ mine.name
      end

      # ...and no orgfiles from other users
      for not_mine <- context.not_mine do
        refute resp =~ not_mine.name
      end
    end

    test "redirects to login if not logged in", %{conn: conn} do
      assert "/login" == redirected_to(get(conn, "/todos"), 302)
    end
  end
end
