defmodule Macroy do
  alias Macroy.{Repo, OrgFile, User, Todo}
  alias Doorman.Auth.Secret
  import Ecto.Query

  def get_todo(id), do: Repo.get(Todo, id)

  def new_todo, do: Todo.changeset(%Todo{})

  def new_todo(params), do: Todo.changeset(%Todo{}, params)

  def list_todos(id) do
    query = from(t in Todo,
      join: u in assoc(t, :owner),
      left_join: o in assoc(t, :org_file),
      where: u.id == ^id,
      preload: [owner: u, org_file: o]
    )
    Repo.all(query)
  end

  def insert_todo(attrs) do
    %Todo{}
    |> Todo.changeset(attrs)
    |> Repo.insert()
  end

  def list_org_files(id) do
    query = from(f in OrgFile,
      join: u in assoc(f, :owner),
      where: u.id == ^id,
      preload: [owner: u]
    )
    Repo.all(query)
  end

  def new_org_file, do: OrgFile.changeset(%OrgFile{})

  def get_org_file(id), do: Repo.get(OrgFile, id)

  def insert_org_file(attrs) do
    %OrgFile{}
    |> OrgFile.changeset(attrs)
    |> Repo.insert()
  end

  def edit_org_file(id) do
    get_org_file(id)
    |> OrgFile.changeset()
  end

  def update_org_file(%OrgFile{} = orgfile, updates) do
    orgfile
    |> OrgFile.changeset(updates)
    |> Repo.update()
  end

  def new_user, do: User.changeset(%User{})

  def insert_user(user_params) do
    %User{}
    |> User.changeset(user_params)
    |> Secret.put_session_secret()
    |> Repo.insert()
  end

  def upload_sync(orgfile, user_id) do
    case orgfile.host do
      "localhost" ->
        orgfile
        |> Macroy.OrgFile.read
        |> Enum.map(fn todo -> Map.put(todo, :owner_id, user_id) end)
        |> process_todo_sync(orgfile)
    end
  end

  defp does_todo_exist_already?(_orgfile, _orgfile_todo, []) do
    false
  end

  defp does_todo_exist_already?(orgfile, orgfile_todo, [todo|todos]) do
    name_jaro_dist = String.jaro_distance(orgfile_todo.name, todo.name)
    cond do
      name_jaro_dist >= 0.9 -> {true, orgfile_todo}
      true -> does_todo_exist_already?(orgfile, orgfile_todo, todos)
    end
  end

  def does_todo_exist_already?(orgfile = %OrgFile{id: id}, todo) do
    query = from(t in Todo,
      join: of in assoc(t, :org_file),
      where: of.id == ^id,
      preload: [org_file: of]
    )
    case Repo.all(query) do
      [] -> false
      orgfile_todos -> does_todo_exist_already?(orgfile, todo, orgfile_todos)
    end
  end

  defp process_todo_sync(todos, orgfile, processed \\ [], errors \\ [])
  defp process_todo_sync([todo|todos], orgfile, processed, errors) do
    todo = case does_todo_exist_already?(orgfile, todo) do
             {true, existing_todo} -> existing_todo |> Todo.update(todo)
             false -> todo |> Todo.changeset
           end
    case todo.valid? do
      true ->
        process_todo_sync(todos, orgfile, processed ++ [todo.data], errors)
      false ->
        todo_errors = [Keyword.merge(todo.errors, [name: todo.data.name])]
        process_todo_sync(todos, orgfile, processed, errors ++ todo_errors)
    end
  end

  defp process_todo_sync([], orgfile, todos, errors) do
    {processed, _} = Macroy.insert_all_orgfile_todos(
      orgfile,
      todos,
      on_conflict: :replace_all_except_primary_key,
      conflict_target: :id
    )
    msg = "Processed #{Integer.to_string(processed)} todos in #{orgfile.filename}"
    if Enum.empty?(errors) do
      {:ok, msg}
    else
      {:error, msg, errors}
    end
  end

  def insert_all_orgfile_todos(orgfile, todos, opts \\ []) do
    now = NaiveDateTime.utc_now |> NaiveDateTime.truncate(:second)
    todos = Enum.map(todos, fn m ->
      m
      |> Map.put(:updated_at, now)
      |> Map.put(:inserted_at, now)
      |> Map.put(:org_file_id, orgfile.id)
      |> Map.take(Todo.get_todo_fields_and_timestamps())
    end)

    Repo.insert_all(Todo, todos, opts)
  end
end
