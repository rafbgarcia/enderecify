defmodule StatesApi.Resolve.Regiao do
  use StatesApiWeb, :graphql_resolver
  alias StatesApi.Regiao

  def handle(_, _) do
    {:ok, by_nome() |> Repo.all()}
  end

  defp by_nome(query \\ Regiao) do
    query |> order_by(:nome)
  end
end
