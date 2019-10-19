defmodule Macroy.Repo.Migrations.CreateTasks do
  use Ecto.Migration

  def up do
    create table(:tasks) do
      add :name, :string
      add :is_done, :boolean
      add :category, :string
      add :subcategory, :string
      add :closed_on, :utc_datetime
      add :scheduled_for, :utc_datetime
      add :deadline_on, :utc_datetime
      timestamps()
    end
  end

  def down do
    drop table(:tasks)
  end
end
