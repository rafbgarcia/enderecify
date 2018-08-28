defmodule StatesApi.Resolve.Estado do
  use StatesApiWeb, :graphql_resolver
  alias StatesApi.Estado

  def handle(_, _) do
    {:ok, Repo.all(Estado)}
  end
end
