defmodule MacroyWeb.Router do
  use MacroyWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", MacroyWeb do
    pipe_through :browser

    get "/", PageController, :index
    resources "/orgfiles", OrgFileController, only: [
      :index,
      :show,
      :new,
      :create,
      :edit,
      :update
    ]
  end

  # Other scopes may use custom stacks.
  # scope "/api", MacroyWeb do
  #   pipe_through :api
  # end
end
