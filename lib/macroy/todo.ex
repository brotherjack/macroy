defmodule Macroy.Todo do
  alias Macroy.OrgFile
  import Ecto.Changeset
  use Ecto.Schema
  import Kernel
  use Timex

  @moduledoc """
  Todos are things that need to be done and are not, or needed to be done, and
  have been.
  """

  schema "todos" do
    field :name, :string
    field :is_done, :boolean
    field :category, :string
    field :subcategory, :string
    field :closed_on, :utc_datetime
    field :scheduled_for, :utc_datetime
    field :deadline_on, :utc_datetime
    belongs_to :org_file, OrgFile, on_replace: :nilify
    timestamps()
  end

  def changeset(todo, params \\ %{}) do
    todo
    |> cast(params,
    [
      :name,  :is_done, :category, :subcategory,
      :closed_on, :scheduled_for, :deadline_on,
      :org_file_id
    ]
    )
    |> foreign_key_constraint(:org_file_id, name: "todos_org_file_id_fkey")
    |> validate_required([:name, :is_done])
    |> validate_subset(:is_done, [:DONE, :TODO])
  end

  def update(todo, changes \\ %{}) do
    timestamp = NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second)
    todo
    |> change(
      Map.merge(changes, %{updated_at: timestamp}, fn _k, _v1, v2 -> v2 end)
    )
  end
end
