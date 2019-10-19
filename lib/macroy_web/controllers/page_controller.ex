defmodule MacroyWeb.PageController do
  use MacroyWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
