defmodule MacroyWeb.OrgFileController do
  use MacroyWeb, :controller

  def index(conn, _params) do
    orgfiles = Todo.list_org_files()
    render(conn, "index.html", orgfiles: orgfiles)
  end

  def new(conn, _params) do
    orgfile = Todo.new_org_file()
    render(conn, "new.html", orgfile: orgfile)
  end

  def show(conn, %{"id" => id}) do
    orgfile = Todo.get_org_file(id)
    render(conn, "show.html", orgfile: orgfile)
  end

  def create(conn, %{"org_file" => orgfile_params}) do
    case Todo.insert_org_file(orgfile_params) do
      {:ok, orgfile} -> redirect(conn, to: Routes.org_file_path(conn, :show, orgfile))
      {:error, orgfile} -> render(conn, "new.html", orgfile: orgfile)
    end
  end
end
