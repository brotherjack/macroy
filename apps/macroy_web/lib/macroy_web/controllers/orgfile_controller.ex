defmodule MacroyWeb.OrgFileController do
  use MacroyWeb, :controller

  def index(conn, _params) do
    orgfiles = Todo.list_org_files()
    render(conn, "index.html", orgfiles: orgfiles)
  end
end
