defmodule StatesApi.Resolve.Regiao do
  use StatesApiWeb, :graphql_resolver
  alias StatesApi.Regiao

  def handle(%{sigla: sigla}, _) do
    {:ok, Regiao |> Repo.get!(sigla)}
  end

  def handle(%{siglas: siglas}, _) do
    {:ok, with_siglas(siglas) |> by_nome() |> Repo.all() }
  end

  def handle(_, _) do
    {:ok, by_nome() |> Repo.all()}
  end

  defp by_nome(query \\ Regiao) do
    query |> order_by(:nome)
  end

  defp with_siglas(siglas) do
    from(r in Regiao, where: r.sigla in ^siglas)
  end
end
