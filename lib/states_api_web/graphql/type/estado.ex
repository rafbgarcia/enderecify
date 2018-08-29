defmodule StatesApiWeb.Graphql.Type.Estado do
  use StatesApiWeb, :graphql_schema

  object :estado do
    field(:nome, :string)
    field(:sigla, :string)
    field(:cidades, list_of(:localidade), resolve: assoc(:cidades, fn(query, _args, _ctx) ->
      query |> order_by(:nome)
    end))
    field(:regiao, :regiao, resolve: assoc(:regiao))
  end
end
