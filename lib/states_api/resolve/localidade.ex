defmodule StatesApi.Resolve.Localidade do
  use StatesApiWeb, :graphql_resolver
  alias StatesApi.Localidade

  def handle(%{sigla_estado: sigla_estado}, _) do
    {
      :ok,
      with_estado(sigla_estado) |> by_nome() |> Repo.all()
    }
  end

  defp with_estado(query \\ from(e in Localidade), sigla_estado) do
    query |> where(sigla_estado: ^sigla_estado)
  end

  defp by_nome(query \\ Localidade) do
    query |> order_by(:nome)
  end
end
