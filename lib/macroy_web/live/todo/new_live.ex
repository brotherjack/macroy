defmodule MacroyWeb.Live.TodoNew do
  use Phoenix.LiveView
  alias MacroyWeb.TodoView
  alias Macroy.Todo #TODO: Place in macroy.ex
  import Ecto.Changeset

  @necessary_fields [
    :todo, :todo_fields, :csrf_token, :closed_on, :scheduled_for, :deadline_on
  ]

  def mount(_session, socket) do
    {:ok, assign(socket, setup_initial_params())}
  end

  def render(assigns), do: TodoView.render("new.html", assigns)

  def handle_event("set_closed", _, socket) do
    {:noreply, assign(socket, closed_on: not socket.assigns.closed_on)}
  end

  def handle_params(_params, uri, socket) do
    cond do
      not Enum.all?(@necessary_fields, fn a -> a in Map.keys(socket.assigns) end) -> 
        {:noreply, assign(socket, setup_initial_params())}
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

  defp setup_initial_params() do
    %{
      todo: Macroy.new_todo(),
      todo_fields: Todo.get_todo_fields_with_types(),
      csrf_token: Phoenix.Controller.get_csrf_token(),
      closed_on: false,
      scheduled_for: true,
      deadline_on: true
    }
  end
end
