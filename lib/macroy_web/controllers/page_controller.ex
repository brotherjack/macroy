defmodule MacroyWeb.PageController do
  use MacroyWeb, :controller

  def index(conn, params \\ %{}) do
    render(conn, "index.html", params)
  end
end
