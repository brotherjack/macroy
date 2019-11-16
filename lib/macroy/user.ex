defmodule Macroy.User do
  import Ecto.Changeset
  use Ecto.Schema
  import Doorman.Auth.Bcrypt, only: [hash_password: 1]

  schema "users" do
    field :email, :string
    field :hashed_password, :string
    field :password, :string, virtual: true
    field :session_secret, :string

    timestamps()
  end

  def changeset(user, params \\ %{}) do
    user
    |> cast(params, [:email, :password])
    |> hash_password
    |> validate_required([:email, :password])
  end
end
