defmodule MacroyWeb.TodoController do
  use MacroyWeb, :controller
  import Phoenix.LiveView.Controller
  alias Macroy.Todo
  alias MacroyWeb.Live.{TodoIndex, TodoNew}

  def index(conn, _params), do:
    live_render(conn, TodoIndex, session: %{uid: conn.assigns.current_user.id})

  def setup(conn, _params) do
    todo_f = Todo.get_todo_fields_with_types()
    live_render(conn, TodoNew, session: %{
          todo: Macroy.new_todo(%{
                deadline_on: DateTime.utc_now,
                scheduled_for: DateTime.utc_now,
                closed_on: nil
          }),
          todo_fields: todo_f,
          csrf_token: get_csrf_token()
      }
    )
  end

  def create(conn, %{"todo" => todo_params}) do
    inserted_todo = Macroy.insert_todo(todo_params, conn.assigns.current_user.id)

    case inserted_todo do
      {:ok, todo} -> redirect(conn, to: Routes.todo_path(conn, :show, todo))
      {:error, todo} ->
        live_render(conn, TodoNew, session: todo_params)
    end
  end

  def show(conn, %{"id" => id}) do
    todo = id |> Macroy.get_todo()
    if is_nil todo do
      render(conn, "show.html", todo: nil, id: id)
    else
      render(conn, "show.html", todo: todo)
    end
  end
end
