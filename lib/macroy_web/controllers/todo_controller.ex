defmodule MacroyWeb.TodoController do
  use MacroyWeb, :controller
  import Phoenix.LiveView.Controller
  alias Macroy.Todo

  def index(conn, _params) do
    todos = conn.assigns.current_user.id
    |> Macroy.list_todos()

    live_render(conn, MacroyWeb.TodoLive, session: %{todos: todos})
  end

  def new(conn, _params) do
    todo_f = Todo.get_todo_fields_with_types()
    render(conn, "new.html", todo: Macroy.new_todo(), todo_fields: todo_f)
  end

  def create(conn, %{"todo" => todo_params}) do
    inserted_todo = todo_params
    |> Map.put("owner_id", conn.assigns.current_user.id)
    |> Macroy.insert_todo()

    case inserted_todo do
      {:ok, todo} -> redirect(conn, to: Routes.todo_path(conn, :show, todo))
      {:error, todo} -> render(conn, "new.html", todo: todo)
    end
  end

  def show(conn, %{"id" => id}) do
    todo = Macroy.get_todo(id)
    render(conn, "show.html", todo: todo)
  end
end
