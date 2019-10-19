defmodule Macroy.Repo.Migrations.DeUmbrella do
  use Ecto.Migration

  def up do
    rename table("tasks"), to: table("todos")
  end

  def down do
    rename table("todos"), to: table("tasks")
  end
end
