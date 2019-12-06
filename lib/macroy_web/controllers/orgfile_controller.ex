defmodule MacroyWeb.OrgFileController do
  use MacroyWeb, :controller

  def index(conn, params \\ %{}) do
    orgfiles = Macroy.list_org_files(conn.assigns.current_user.id)
    params =  Map.merge(%{orgfiles: orgfiles}, params, fn _k, v1, _v2 -> v1 end)
    render(conn, "index.html", params)
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
    inserted_orgfile = orgfile_params
    |> Map.put("owner_id", conn.assigns.current_user.id)
    |> Macroy.insert_org_file()

    case inserted_orgfile do
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
    |> Macroy.upload_sync(conn.assigns.current_user.id)
    case orgfile do
      {:ok, msg} ->
        conn
        |> put_flash(:success, msg)
        |> redirect(to: Routes.org_file_path(conn, :index))
      {:error, msg, _errors} ->
        conn
        |> put_flash(:danger, msg)
        |> redirect(to: Routes.org_file_path(conn, :index))
    end
  end
end
