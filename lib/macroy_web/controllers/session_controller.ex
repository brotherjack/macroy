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
      |> redirect(to: Routes.user_path(conn, :new))
    end
  end

  def signin(conn, _params) do
    new_session = %{"session" => %{"email" => nil, "password" => nil}}
    render(conn, "login.html", session: new_session)
  end

  def logout(conn, _) do
    conn
    |> clear_session
    |> put_flash(:notice, "Byeeeee!")
    |> redirect(to: Routes.page_path(conn, :index))
  end
end

