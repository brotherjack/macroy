# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :macroy,
  ecto_repos: [Macroy.Repo]

# Configures the endpoint
config :macroy, MacroyWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "VnPtEPAJpgFi+Sx5d9lFSLLaJHpuocfYA6BBtsTHqUMT6xl4grqIfNjFj8RHJFzE",
  render_errors: [view: MacroyWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: MacroyWeb.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Todo stuffs
config :macroy, ecto_repos: [Macroy.Repo]

config :doorman,
  repo: Macroy.Repo,
  secure_with: Doorman.Auth.Bcrypt,
  user_module: Macroy.User

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
