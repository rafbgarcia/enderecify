ExUnit.start()

# Ecto.Adapters.SQL.Sandbox.mode(StatesApi.Repo, :manual)
Ecto.Adapters.SQL.Sandbox.mode(StatesApi.Repo, {:shared, self()})

