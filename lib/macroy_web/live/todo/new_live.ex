defmodule MacroyWeb.Live.TodoNew do
  use Phoenix.LiveView
  alias MacroyWeb.TodoView
  import Ecto.Changeset
  require Logger
  alias MacroyWeb.Router.Helpers, as: Routes

  def mount(%{user_id: user_id}, socket) do
    {:ok, setup_initial_params(socket, user_id)}
  end

  def render(assigns), do: TodoView.render("new.html", assigns)

  def handle_event("validate", %{"todo" => todo_params}, socket) do
    todo_params = Enum.map(todo_params, fn {k,v} -> {String.to_atom(k), v} end)
    changeset = Macroy.update_todo(socket.assigns.todo, todo_params) 
      
    {:noreply, assign(socket, todo: changeset)}
  end

  def handle_event("insert_todo", %{"todo" => todo_params}, socket) do
    IO.inspect todo_params
    inserted_todo = todo_params
    |> Macroy.insert_todo(socket.assigns.user_id)
    |> IO.inspect

    case inserted_todo do
      {:ok, todo} ->
        {:stop, redirect(socket, to: Routes.todo_path(socket, :show, todo))}
      {:error, todo} -> {:noreply, assign(socket, todo: todo)} 
    end
  end

  def handle_params(params, uri, socket) do
    IO.inspect params
    cond do
      String.contains?(uri, "closed_on=click") ->
        socket = toggle_datetime(socket, :closed_on)
        {:noreply, assign(socket, closed_on: not socket.assigns.closed_on)}
      String.contains?(uri, "scheduled_for=click") ->
        socket = toggle_datetime(socket, :scheduled_for)
        {:noreply ,assign(socket, scheduled_for: not socket.assigns.scheduled_for)}
      String.contains?(uri, "deadline_on=click") ->
        socket = toggle_datetime(socket, :deadline_on)
        {:noreply, assign(socket, deadline_on: not socket.assigns.deadline_on)}
      true ->
        {:noreply, socket}
    end
    
  end

  defp toggle_datetime(socket, param) do
    if Map.get(socket.assigns, param) do
      todo = socket.assigns.todo |> change([{param, nil}])
      assign(socket, todo: todo)
    else
      todo = socket.assigns.todo |> change([{param, DateTime.utc_now}])
      assign(socket, todo: todo)
    end
  end

  defp setup_initial_params(socket, id) do
    new_todo_params = %{
          deadline_on: DateTime.utc_now,
          scheduled_for: DateTime.utc_now,
          closed_on: nil
    }
    socket
    |> assign_new(:todo, fn -> Macroy.new_todo(new_todo_params) end) 
    |> assign_new(:closed_on, fn -> false end)
    |> assign_new(:scheduled_for, fn -> true end)
    |> assign_new(:deadline_on, fn -> true end)
    |> assign_new(:user_id, fn -> Macroy.get_user(id)  end)
    |> assign_new(:flash, fn -> nil end)
  end
end
