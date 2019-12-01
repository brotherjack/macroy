defmodule MacroyWeb.Router do
  use MacroyWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug Doorman.Login.Session
    plug :fetch_flash
    plug Phoenix.LiveView.Flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", MacroyWeb do
    pipe_through :browser

    get "/", PageController, :index

    resources "/user", UserController, only: [:new, :create]
    get "/login", SessionController, :signin
    post "/login", SessionController, :create
    get "/logout", SessionController, :logout

    scope "/orgfiles" do
      pipe_through MacroyWeb.RequireLogin
      resources "/", OrgFileController, only: [
        :index,
        :show,
        :new,
        :create,
        :edit,
        :update
      ]
      get "/upload/:id", OrgFileController, :upload
    end

    scope "/todos" do
      pipe_through MacroyWeb.RequireLogin
      resources "/", TodoController, only: [:index]
    end
  end
  # Other scopes may use custom stacks.
  # scope "/api", MacroyWeb do
  #   pipe_through :api
  # end
end
