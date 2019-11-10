defmodule MacroyWeb.OrgFileController do
  use MacroyWeb, :controller

  def index(conn, _params) do
    orgfiles = Macroy.list_org_files()
    render(conn, "index.html", orgfiles: orgfiles)
  end

  def new(conn, _params) do
    orgfile = Macroy.new_org_file()
    render(conn, "new.html", orgfile: orgfile)
  end

  def show(conn, %{"id" => id}) do
    orgfile = Macroy.get_org_file(id)
    render(conn, "show.html", orgfile: orgfile)
  end

  def create(conn, %{"org_file" => orgfile_params}) do
    case Macroy.insert_org_file(orgfile_params) do
      {:ok, orgfile} -> redirect(conn, to: Routes.org_file_path(conn, :show, orgfile))
      {:error, orgfile} -> render(conn, "new.html", orgfile: orgfile)
    end
  end

  def edit(conn, %{"id" => id}) do
    orgfile = Macroy.edit_org_file(id)
    render(conn, "edit.html", orgfile: orgfile)
  end

  def update(conn, %{"id" => id, "org_file" => orgfile_params}) do
    orgfile = Macroy.get_org_file(id)
    case Macroy.update_org_file(orgfile, orgfile_params)do
      {:ok, orgfile} -> redirect(conn, to: Routes.org_file_path(conn, :show, orgfile))
      {:error, orgfile} -> render(conn, "edit.html", orgfile: orgfile)
    end
  end

  def upload(conn, %{"id" => id}) do
    orgfile = id
    |> Macroy.get_org_file
    opts = orgfile
    |> Macroy.upload_sync
    |> upload_opts(orgfile)
    redirect(conn, to: Routes.org_file_path(conn, :index, opts))
  end

  defp upload_opts(res, orgfile) do
    case res do
      {:ok, msg} -> [orgfile: orgfile, msg: msg, result: "success"]
      {:error, msg} -> [orgfile: orgfile, msg: msg, result: "danger"]
    end
  end
end
