defmodule Macroy.Repo.Migrations.TodoIsDoneFieldCanNoLongerBeNull do
  use Ecto.Migration

  def up do
    alter table("todos"), do: modify :is_done, :boolean, null: false
  end

  def down do
    alter table("todos"), do: modify :is_done, :boolean, null: true
  end
end
