defmodule Macroy.Repo.Migrations.SetupAOneToManyRelationshipBetweenOrgfileAndTodos do
  use Ecto.Migration

  def up do
    alter table("todos") do
      add :org_file_id, references(:orgfiles, on_delete: :nilify_all), null: true
    end
  end

  def down do
    alter table("todos") do
      remove :org_file_id
    end
  end
end
