defmodule Todo.OrgFile do
  import Ecto.Changeset
  use Ecto.Schema
  alias Todo.Task, as: Todo

  @moduledoc """
  OrgFiles are files containing `Todo.Tasks`.
  """
  schema "orgfiles" do
    field :host, :string, default: "localhost"
    field :path, :string
    field :filename, :string
    timestamps()
  end

  def changeset(orgfile, params \\ %{}) do
    orgfile
    |> cast(params, [:host, :path, :filename])
    |> validate_required([:path, :filename])
  end

  @doc """
  Reads an org file containing todos in the following format:
  * {Category}
  ** {Subcategory}
  TODO|DONE {name} 
  {Sched}

  Returns a list of Todos
  """
  @spec read(OrgFile) :: [Todo]
  def read(orgf) do
    ofpath = Path.join(orgf.path, orgf.filename)
    parse(prep_org_file_stream(ofpath), %Todo{}, [], nil, nil)
  end

  defp prep_org_file_stream(path) do
    File.stream!(path) |>
      Stream.map(&String.split(&1, "\n", trim: true)) |>
      Enum.to_list |>
      List.flatten |>
      Enum.filter(fn x -> x != "" end) 
  end

  def parse([], %Todo{}, todos, _category, _subcategory) do
    todos
  end

  def parse([], task, todos, _category, _subcategory) do
    todos ++ [task]
  end

  def parse([h|t], task, todos, category, subcategory) do
    task = task |>
      Map.put(:category, category) |>
      Map.put(:subcategory, subcategory)
    next_line = parse_line(h)
    case next_line do
      {:sched, sched} ->
        parse(
          t,
          %Todo{},
          todos ++ [Map.merge(task, sched, fn _k,v1,v2 -> v1 || v2 end)],
          category,
          subcategory
        )
      {:name, new_task} ->
        parse(t, new_task, todos, category, subcategory)
      {:cat, new_category} ->
        parse(t, task, todos, new_category, subcategory)
      {:subcat, new_subcategory} ->
        parse(t, task, todos, category, new_subcategory)
      {:nothing, _} -> # TODO Add logger and pass line to it
        parse(t, task, todos, category, subcategory)
    end
  end

  defp parse_line(line) do
    cond do
      String.contains?(line, ["CLOSED", "DEADLINE", "SCHEDULED"]) ->
        {:sched, get_sched(line)}
      String.contains?(line, ["TODO", "DONE"]) -> {:name, get_name(line)}
      String.match?(line, ~r/\*\*+ (.+)/) -> {:subcat, get_subcategory(line)}
      String.match?(line, ~r/\* (.+)/) -> {:cat, get_category(line)}
      true -> {:nothing, line}
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
    Enum.reduce(captures, %Todo{}, fn c, acc ->
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
    %Todo{}
    |> Map.put(:is_done, if Enum.at(matches, 1) == "TODO" do false else true end)
    |> Map.put(:name, Enum.at(matches, 2))
  end
end