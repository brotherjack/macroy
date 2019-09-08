defmodule Todo do
  alias Todo.Task, as: Task
  alias Todo.OrgFile, as: OrgFile

  @repo Todo.Repo

  def list_org_files do
    @repo.all(OrgFile)
  end
end
