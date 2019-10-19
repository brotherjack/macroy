defmodule Macroy.Todo do
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
    timestamps()
  end

  def changeset(todo, params \\ %{}) do
    todo
    |> cast(params,
    [
      :name,  :is_done, :category, :subcategory,
      :closed_on, :scheduled_for, :deadline_on
    ]
    )
    |> validate_required([:name, :is_done])
    |> validate_subset(:is_done, [:DONE, :TODO])
  end
end
