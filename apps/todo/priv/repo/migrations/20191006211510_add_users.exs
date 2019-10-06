defmodule Todo.Repo.Migrations.AddUsers do
  use Ecto.Migration

  def up do
    create table(:users) do
      add :email, :string
      add :hashed_password, :string
      add :session_secret, :string
      timestamps()
    end
  end

  def down do
    drop table(:users)
  end
end
