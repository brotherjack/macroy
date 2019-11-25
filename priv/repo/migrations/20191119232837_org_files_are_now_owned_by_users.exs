defmodule Macroy.Repo.Migrations.OrgFilesAreNowOwnedByUsers do
  use Ecto.Migration

  def up do
    alter table("orgfiles") do
      add :owner_id, references(:users, on_delete: :delete_all), null: false
    end
  end

  def down do
    alter table("orgfiles") do
      remove :owner_id
    end
  end
end
