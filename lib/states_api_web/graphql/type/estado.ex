defmodule StatesApiWeb.Graphql.Type.Estado do
  use StatesApiWeb, :graphql_schema

  object :estado do
    field(:nome, :string)
    field(:sigla, :string)
    field(:regiao, :regiao, resolve: assoc(:regiao))
  end
end
