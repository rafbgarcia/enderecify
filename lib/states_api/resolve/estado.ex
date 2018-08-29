defmodule StatesApi.Resolve.Estado do
  use StatesApiWeb, :graphql_resolver
  alias StatesApi.Estado

  def handle(%{sigla: sigla}, _) do
    {:ok, find(sigla)}
  end

  def handle(%{sigla_regiao: sigla_regiao}, _) do
    {
      :ok,
      with_region(sigla_regiao) |> by_nome() |> Repo.all()
    }
  end

  def handle(_, _) do
    {
      :ok,
      Estado |> by_nome() |> Repo.all()
    }
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
