defmodule StatesApi.Resolve.Bairro do
  use StatesApiWeb, :graphql_resolver
  alias StatesApi.Bairro

  def handle(%{localidade_id: localidade_id}, _) do
    {
      :ok,
      with_localidade(localidade_id) |> by_nome() |> Repo.all()
    }
  end

  defp with_localidade(query \\ from(b in Bairro), localidade_id) do
    query |> where(localidade_id: ^localidade_id)
  end

  defp by_nome(query) do
    query |> order_by(:nome)
  end
end
