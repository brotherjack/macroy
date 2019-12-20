defmodule MacroyWeb.Live.TodoIndex do
  use Phoenix.LiveView
  alias MacroyWeb.TodoView
  alias Macroy.Todo

  require Logger

  def mount(%{uid: userid}, socket) do
    {:ok, setup_assigns(userid, socket)}
  end

  def render(assigns), do: TodoView.render("index.html", assigns)

  def setup_initial_todo_sort() do
    for field <- Todo.get_todo_fields() -- [:owner_id] do
      {field, ""}
    end
  end

  defp setup_assigns(user_id, socket) do
    assign(socket,
      user_id: user_id,
      todos: Macroy.list_todos(user_id),
      todo_sorts: setup_initial_todo_sort(),
      todo: nil,
      flash: nil
    )
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

  def handle_event("maybe_delete_todo", %{"todo" => id}, socket) do
    todo = id |> Macroy.get_todo()
    {:noreply, assign(socket, todo: todo)}
  end

  def handle_event("definitely_delete_todo", %{"todo" => id}, socket) do
    case Macroy.delete_todo(id) do
      {:ok, msg} ->
        {:noreply,
         assign(socket,
            flash: {:success, msg},
            todo: nil,
            todos: Macroy.list_todos(socket.assigns.user_id))
        }
      {:error, todo} ->
        msg = "Could not delete #{todo.name}!"
        {:noreply, assign(socket, flash: {:danger, msg}, todo: nil)}
    end
  end

  def handle_event("do_not_delete_todo", _params, socket) do
    {:noreply, assign(socket, todo: nil)}
  end

  def handle_event("kill_me", _, socket) do
    {:noreply, assign(socket, flash: nil)}
  end
end
