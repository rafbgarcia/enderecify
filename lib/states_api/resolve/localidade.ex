defmodule StatesApi.Resolve.Localidade do
  use StatesApiWeb, :graphql_resolver
  alias StatesApi.Localidade

  def handle(%{sigla: sigla}, _) do
    {:ok, find(sigla)}
  end

  defp find(sigla) do
    Estado |> Repo.get!(sigla)
  end

  defp with_region(sigla_regiao) do
    from(e in Estado, where: e.sigla_regiao == ^sigla_regiao)
  end

  defp by_nome(query) do
    query |> order_by(:nome)
  end
end
