defmodule MacroyWeb.SessionController do
  use MacroyWeb, :controller
  import Doorman.Login.Session, only: [login: 2]

  def create(conn, %{"session" => %{"email" => email, "password" => password}}) do
    if user = Doorman.authenticate(email, password) do
      conn
      |> login(user) # Sets :user_id and :session_secret on conn's session
      |> put_flash(:notice, "Successfully logged in")
      |> redirect(to: "/")
    else
      conn
      |> put_flash(:error, "No user found with the provided credentials")
      |> render("new.html")
    end
  end
end

