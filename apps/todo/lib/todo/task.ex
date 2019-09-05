defmodule Todo.Task do
  import Ecto.Changeset
  use Ecto.Schema
  import Kernel
  use Timex

  @moduledoc """
  Todos are things that need to be done and are not, or needed to be done, and
  have been.
  """

  schema "tasks" do
    field :name, :string
    field :is_done, :boolean
    field :category, :string
    field :subcategory, :string
    field :closed_on, :utc_datetime
    field :scheduled_for, :utc_datetime
    field :deadline_on, :utc_datetime
    timestamps()
  end

  def changeset(todo, params \\ %{}) do
    todo
    |> cast(params,
    [
      :name,  :is_done, :category, :subcategory,
      :closed_on, :scheduled_for, :deadline_on
    ]
    )
    |> validate_required([:name, :is_done])
    |> validate_subset(:is_done, [:DONE, :TODO])
  end

  @doc """
  Reads an org file containing todos in the following format:
  * {Category}
  ** {Subcategory}
  TODO|DONE {name} 
  {Sched}

  Returns a list of Todos
  """
  @spec read_org_file(string) :: [Todo.Task]
  def read_org_file(path) do
    todos = File.stream!(path) |>
      Stream.map(&String.split(&1, "\n", trim: true)) |>
      Enum.to_list |>
      List.flatten |>
      Enum.filter(fn x -> x != "" end)
      readtodo(%Todo.Task{}, todos, [], nil, nil)
  end

  defp readtodo(%Todo.Task{}, [], todos, _, _) do
    todos
  end

  defp readtodo(todo, [], _todos, _category, _subcategory) do
    todo
  end

  defp readtodo(todo, [h|t], todos, category, subcategory) do
    todo = todo |>
      Map.put(:category, category) |>
      Map.put(:subcategory, subcategory)
    cond do
      String.contains?(h, ["CLOSED", "DEADLINE", "SCHEDULED"]) ->
        if Map.has_key?(todo, :name)  do
          readtodo(
            %Todo.Task{}, t, todos ++ [
              Map.merge(get_sched(h), todo, fn _k,v1,v2 -> v1 || v2 end)
            ], category, subcategory)
        else
          raise RuntimeError, "Todo not found for schedule field!"
        end
      String.contains?(h, ["TODO", "DONE"]) ->
        Map.merge(todo, get_name(h), fn _k,_v1,v2 -> v2 end)
        |> readtodo(t, todos, category, subcategory)
      String.match?(h, ~r/\*\*+ (.+)/) ->
        readtodo(todo, t, todos, category,  get_subcategory(h))
      String.match?(h, ~r/\* (.+)/) ->
        readtodo(todo, t, todos, get_category(h), subcategory)
    end
  end

  defp convert_sched_to_datetime(sched) when elem(sched,1) == nil do
    {String.to_atom(elem(sched,0)), elem(sched, 1)}
  end

  defp convert_sched_to_datetime(sched) do
    datet = if String.length(elem(sched,1)) > 14 do
      Timex.parse!(elem(sched, 1), "%Y-%m-%d %a %H:%M", :strftime)
    else
      Timex.parse!(elem(sched, 1), "%Y-%m-%d %a", :strftime)
    end
    |> Timex.to_datetime(System.get_env("tzone"))
    |> Timex.Timezone.convert("Etc/UTC")
    {String.to_atom(elem(sched,0)), datet}
  end

  defp get_sched(line) do
    captures = [
      ~r/CLOSED: \[(?<closed_on>[0-9 A-Za-z\:\-]+)\]/,
      ~r/DEADLINE: <(?<deadline_on>[0-9 A-Za-z\:\-]+)>/,
      ~r/SCHEDULED: <(?<scheduled_for>[0-9 A-Za-z\:\-]+)>/
    ]
    Enum.reduce(captures, %Todo.Task{}, fn c, acc ->
      (Regex.named_captures(c, line) || %{Enum.at(Regex.names(c), 0) => nil}) |>
      Map.new(fn x -> convert_sched_to_datetime(x) end) |>
      Map.merge(acc, fn _k,v1,v2 -> v1 || v2 end)
    end)
  end

  defp get_category(line) do
    Enum.at(Regex.run(~r/\* (.*)/, line), 1)
  end

  defp get_subcategory(line) do
    Enum.at(Regex.run(~r/\*+ (.+)/, line), 1)
  end

  defp get_name(line) do
    matches = Regex.run(~r/\**\w?(TODO|DONE) (.+)/, line)
    Map.new
    |> Map.put(:is_done, if Enum.at(matches, 1) == "TODO" do true else false end)
    |> Map.put(:name, Enum.at(matches, 2))
  end
end
