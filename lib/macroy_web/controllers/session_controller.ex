defmodule MacroyWeb.SessionController do
  use MacroyWeb, :controller
  import Doorman.Login.Session, only: [login: 2]

  def create(conn, %{"session" => %{"email" => email, "password" => password}}) do
    if user = Doorman.authenticate(email, password) do
      conn
      |> login(user) # Sets :user_id and :session_secret on conn's session
      |> put_flash(:success, "Successfully logged in")
      |> redirect(to: Routes.page_path(conn, :index, %{msg_type: :success}))
    else
      conn
      |> put_flash(:danger, "No user found with the provided credentials")
      |> redirect(to: Routes.page_path(conn, :index, %{msg_type: :danger}))
    end
  end

  def signin(conn, _params) do
    new_session = %{"session" => %{"email" => nil, "password" => nil}}
    render(conn, "login.html", session: new_session)
  end

  def logout(conn, _) do
    conn
    |> clear_session
    |> put_flash(:success, "Byeeeee!")
    |> redirect(to: Routes.page_path(conn, :index, %{msg_type: :success}))
  end
end

