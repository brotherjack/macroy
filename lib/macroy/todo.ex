defmodule Macroy.Todo do
  alias Macroy.{OrgFile, User}
  import Ecto.Changeset
  use Ecto.Schema
  import Kernel
  use Timex

  require Logger

  @moduledoc """
  Todos are things that need to be done and are not, or needed to be done, and
  have been.
  """

  @type t :: %__MODULE__{
    name: String.t(), is_done: boolean, category: String.t(),
    subcategory: String.t(), closed_on: DateTime.t(),
    scheduled_for: DateTime.t(), deadline_on: DateTime.t(),
    org_file: OrgFile.t() | nil
  }

  schema "todos" do
    field :name, :string
    field :is_done, :boolean
    field :category, :string
    field :subcategory, :string
    field :closed_on, :utc_datetime
    field :scheduled_for, :utc_datetime
    field :deadline_on, :utc_datetime
    belongs_to :owner, User, on_replace: :delete
    belongs_to :org_file, OrgFile, on_replace: :nilify
    timestamps()
  end

  def changeset(todo, params \\ %{}) do
    todo
    |> cast(params, get_todo_fields())
    |> foreign_key_constraint(:org_file_id, name: "todos_org_file_id_fkey")
    |> foreign_key_constraint(:owner_id, name: "todos_user_id_fkey")
    |> validate_required([:name, :is_done])
    |> validate_subset(:is_done, [:DONE, :TODO])
  end

  def update(todo, changes \\ %{}) do
    timestamp = NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second)

    todo
    |> change(changes |> destruct_if_need_be |> Map.put(:updated_at, timestamp))
  end

  def get_todo_fields() do
    [
      :name,  :is_done, :category, :subcategory,
      :closed_on, :scheduled_for, :deadline_on,
      :org_file_id, :owner_id
    ]
  end

  def get_todo_fields_and_timestamps() do
    get_todo_fields() ++ [:updated_at, :inserted_at]
  end

  defp destruct_if_need_be(changes = %Macroy.Todo{}) do
    Map.take(changes, get_todo_fields_and_timestamps())
  end

  defp destruct_if_need_be(changes = %{}) do
    changes
  end

  defp destruct_if_need_be(_changes) do
    Logger.warn("Changes is not a Todo struct or map")
  end
end
