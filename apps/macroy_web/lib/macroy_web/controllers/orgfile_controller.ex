defmodule MacroyWeb.OrgFileController do
  use MacroyWeb, :controller

  def index(conn, _params) do
    orgfiles = Todo.list_org_files()
    render(conn, "index.html", orgfiles: orgfiles)
  end

  def show(conn, %{"id" => id}) do
    orgfile = Todo.get_org_file(id)
    render(conn, "show.html", orgfile: orgfile)
  end
end
