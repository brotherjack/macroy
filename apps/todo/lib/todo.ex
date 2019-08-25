defmodule Todo do
  @moduledoc """
  Todos are things that need to be done and are not, or needed to be done, and
  have been.
  """


  defstruct [:category, :subcategory, :name, :closed, :deadline, :schedule]
  import Kernel

  @doc """
  Reads an org file containing todos in the following format:
  * {Category}
  ** {Subcategory}
  TODO|DONE {name} 
  {Sched}

  Returns a list of Todos
  """
  @spec read_org_file(string) :: [Todo]
  def read_org_file(path) do
    todos = File.stream!(path) |>
      Stream.map(&String.split(&1, "\n", trim: true)) |>
      Enum.to_list |>
      List.flatten |>
      Enum.filter(fn x -> x != "" end)
      readtodo(%Todo{}, todos, [], nil, nil)
  end

  defp readtodo(%Todo{}, [], todos, _, _) do
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
            %Todo{}, t, todos ++ [
              Map.merge(get_sched(h), todo, fn _k,v1,v2 -> v1 || v2 end)
            ], category, subcategory)
        else
          raise RuntimeError, "Todo not found for schedule field!"
        end
      String.contains?(h, ["TODO", "DONE"]) ->
        readtodo(Map.put(todo,  :name, get_name(h)), t, todos, category, subcategory)
      String.match?(h, ~r/\*\*+ (.+)/) ->
        readtodo(todo, t, todos, category,  get_subcategory(h))
      String.match?(h, ~r/\* (.+)/) ->
        readtodo(todo, t, todos, get_category(h), subcategory)
    end
  end

  defp get_sched(line) do
    captures = [
      ~r/CLOSED: \[(?<closed>[0-9 A-Za-z\:\-]+)\]/,
      ~r/DEADLINE: <(?<deadline>[0-9 A-Za-z\:\-]+)>/,
      ~r/SCHEDULED: <(?<schedule>[0-9 A-Za-z\:\-]+)>/
    ]
    Enum.reduce(captures, %Todo{}, fn c, acc ->
      (Regex.named_captures(c, line) || %{Enum.at(Regex.names(c), 0) => nil}) |>
      Map.new(fn x -> {String.to_atom(elem(x,0)), elem(x,1)} end) |>
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
    Regex.run(~r/\**\w?(TODO|DONE) (.+)/, line) |>
    (&{String.to_atom(Enum.at(&1,1)), Enum.at(&1, 2)}).()
  end
end
