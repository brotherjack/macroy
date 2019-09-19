defmodule Todo do
  alias Todo.Task, as: Task
  alias Todo.OrgFile, as: OrgFile

  @repo Todo.Repo

  def list_org_files do
    @repo.all(OrgFile)
  end

  def new_org_file, do: OrgFile.changeset(%OrgFile{})

  def get_org_file(id), do: @repo.get!(OrgFile, id)

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
end
