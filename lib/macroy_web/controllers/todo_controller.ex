defmodule MacroyWeb.TodoController do
  use MacroyWeb, :controller
  import Phoenix.LiveView.Controller

  def index(conn, _params) do
    todos = conn.assigns.current_user.id
    |> Macroy.list_todos()

    live_render(conn, MacroyWeb.TodoLive, session: %{todos: todos})
  end
end
