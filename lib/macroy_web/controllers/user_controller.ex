defmodule MacroyWeb.UserController do
  use MacroyWeb, :controller

  def new(conn, _params) do
    changeset = Macroy.new_user()
    render(conn, "new.html", user: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    case Macroy.insert_user(user_params) do
      {:ok, user} ->
        conn
        |> put_flash(
          :success,
          "You have setup a user with email '#{user.email}'."
        )
        |> redirect(to: Routes.page_path(conn, :index, %{msg_type: :success}))
      {:error, changeset} ->
        conn
        |> put_flash(:danger, "There are errors in your submission.")
        |> render("new.html", user: changeset, msg_type: :danger)
    end
  end
end
