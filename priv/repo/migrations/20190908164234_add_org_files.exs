defmodule Macroy.Repo.Migrations.AddOrgFiles do
  use Ecto.Migration

  def up do
    create table(:orgfiles) do
      add :host, :string
      add :path, :string
      add :filename, :string
      timestamps()
    end
  end

  def down do
    drop table(:orgfiles)
  end
end
