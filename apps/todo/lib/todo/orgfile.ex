defmodule Todo.OrgFile do
  import Ecto.Changeset
  use Ecto.Schema

  @moduledoc """
  OrgFiles are files containing `Todo.Tasks`.
  """
  schema "orgfiles" do
    field :host, :string, default: "localhost"
    field :path, :string
    field :filename, :string
    timestamps()
  end

  def changeset(orgfile, params \\ %{}) do
    orgfile
    |> cast(params, [:host, :path, :filename])
    |> validate_required [:path, :filename]
  end
end
