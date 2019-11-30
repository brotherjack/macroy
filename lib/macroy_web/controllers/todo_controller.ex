defmodule MacroyWeb.TodoController do
  use MacroyWeb, :controller

  def index(conn, params \\ %{}) do
    todos = Macroy.list_todos(conn.assigns.current_user.id)
    params = params |> Map.put(:todos, todos)
    render(conn, "index.html", params)
  end
end
