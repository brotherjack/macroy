defmodule Macroy do
  alias Macroy.{OrgFile, User, Todo}
  alias Doorman.Auth.Secret
  import Ecto.Query

  @repo Macroy.Repo

  def list_org_files do
    @repo.all(OrgFile)
  end

  def new_org_file, do: OrgFile.changeset(%OrgFile{})

  def get_org_file(id), do: @repo.get(OrgFile, id)

  def insert_org_file(attrs) do
    %OrgFile{}
    |> OrgFile.changeset(attrs)
    |> @repo.insert()
  end

  def edit_org_file(id) do
    get_org_file(id)
    |> OrgFile.changeset()
  end

  def update_org_file(%OrgFile{} = orgfile, updates) do
    orgfile
    |> OrgFile.changeset(updates)
    |> @repo.update()
  end

  def new_user, do: User.create_changeset(%User{})

  def insert_user(user_params) do
    user = %User{}
    |> User.create_changeset(user_params)
    |> Secret.put_session_secret()
    @repo.insert(user)
    {:ok, user}
  end

  def upload_sync(orgfile) do
    case orgfile.host do
      "localhost" ->
        orgfile
        |> Macroy.OrgFile.read
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
    case @repo.all(query) do
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
    
    @repo.insert_all(Todo, todos, opts)
  end
end