defmodule MacroyWeb.Live.TodoIndex do
  use Phoenix.LiveView
  alias MacroyWeb.TodoView
  alias Macroy.Todo

  require Logger

  def mount(%{todos: todos}, socket) do
    {:ok, assign(socket, todos: todos, todo_sorts: setup_initial_todo_sort())}
  end

  def render(assigns), do: TodoView.render("index.html", assigns)

  def setup_initial_todo_sort() do
    for field <- Todo.get_todo_fields() -- [:owner_id] do
      {field, ""}
    end
  end

  def handle_event("sort_by_column", %{"column" => col}, socket) do
    with todo_sorts <- socket.assigns.todo_sorts,
         todos <- socket.assigns.todos,
           col <- String.to_atom(col) do

      case Keyword.get(todo_sorts, col) do
        "ASC" ->
          Logger.debug("Was ASC, becoming DSC")
          sorts = Keyword.put(todo_sorts, col, "DSC")
          todos = todos
          |> Enum.sort(fn(t1, t2) -> Map.get(t1, col) <= Map.get(t2, col) end)
          {:noreply, assign(socket, todos: todos, todo_sorts: sorts)}
        "DSC" ->
          Logger.debug("Was DSC, becoming ASC")
          sorts = Keyword.put(todo_sorts, col, "ASC")
          todos = todos
          |> Enum.sort(fn(t1, t2) -> Map.get(t1, col) >= Map.get(t2, col) end)
          {:noreply, assign(socket, todos: todos, todo_sorts: sorts)}
        _ ->
          Logger.debug("Was unsorted, becoming DSC")
          sorts = Keyword.put(todo_sorts, col, "DSC")
          todos = todos
          |> Enum.sort(fn(t1, t2) -> Map.get(t1, col) <= Map.get(t2, col) end)
          {:noreply, assign(socket, todos: todos, todo_sorts: sorts)}
      end
    end
  end
end
