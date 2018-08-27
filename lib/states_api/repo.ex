defmodule StatesApi.Repo do
  use Ecto.Repo,
    otp_app: :states_api,
    adapter: Ecto.Adapters.Postgres
end
