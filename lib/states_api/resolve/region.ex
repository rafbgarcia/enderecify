defmodule StatesApi.Resolve.Regiao do
  use StatesApiWeb, :graphql_resolver
  alias StatesApi.Regiao

  def handle(_, _) do
    {:ok, Repo.all(Regiao)}
  end
end
