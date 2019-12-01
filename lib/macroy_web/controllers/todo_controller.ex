defmodule MacroyWeb.TodoController do
  use MacroyWeb, :controller
  import Phoenix.LiveView.Controller

  def index(conn, _params) do
    todos = Macroy.list_todos(conn.assigns.current_user.id)
    live_render(conn, MacroyWeb.TodoLive, session: %{todos: todos})
  end
end
