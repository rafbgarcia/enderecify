use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :states_api, StatesApiWeb.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :states_api, StatesApi.Repo,
  username: "postgres",
  password: "postgres",
  database: "states_api_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
