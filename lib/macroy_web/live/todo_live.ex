defmodule MacroyWeb.TodoLive do
  use Phoenix.LiveView
  alias MacroyWeb.TodoView

  def mount(%{todos: todos}, socket) do
    {:ok, assign(socket, todos: todos)}
  end

  def render(assigns), do: TodoView.render("index.html", assigns)
end
