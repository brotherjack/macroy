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


  @spec email_regex() :: %Regex{}
  @doc """
  Returns an valid email regex. 
  """
  def email_regex do
    ~r/^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$/
  end

  def changeset(user, params \\ %{}) do
    user
    |> cast(params, [:email, :password])
    |> hash_password
    |> validate_required([:email, :password])
    |> validate_format(:email, email_regex())
  end
end
