# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :states_api,
  ecto_repos: [StatesApi.Repo]

# Configures the endpoint
config :states_api, StatesApiWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "MWmNbSbMdNsD1qdhoo40X6ow2eTIzHTOfkcffZui++Lj4oXU6HuKjDhCzZXOfoDV",
  render_errors: [view: StatesApiWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: StatesApi.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix and Ecto
config :phoenix, :json_library, Jason
config :ecto, :json_library, Jason


# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
