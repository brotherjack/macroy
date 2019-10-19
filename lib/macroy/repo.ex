defmodule Macroy.Repo do
  use Ecto.Repo,
    otp_app: :macroy,
    adapter: Ecto.Adapters.Postgres
end

