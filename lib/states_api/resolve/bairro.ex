defmodule StatesApi.Resolve.Bairro do
  use StatesApiWeb, :graphql_resolver
  alias StatesApi.Bairro

  def handle(%{sigla: sigla}, _) do
    {:ok, Bairro |> Repo.get!(sigla)}
  end

  defp by_nome(query \\ Bairro) do
    query |> order_by(:nome)
  end
end
