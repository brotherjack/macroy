defmodule MacroyWeb.UserController do
  use MacroyWeb, :controller
  import Ecto.Changeset, only: [get_field: 2]

  def new(conn, _params) do
    changeset = Macroy.new_user()
    render(conn, "new.html", user: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    case Macroy.insert_user(user_params) do
      {:ok, user} -> conn
      |> put_flash( # TODO Figure out how to get the flash to work
        :notice,
        "You have setup a user with email'" <> get_field(user, :email) <> "'."
      )
      |> redirect(to: "/")
      {:error, changeset} -> render(conn, "new.html", user: changeset)
    end
  end
end
