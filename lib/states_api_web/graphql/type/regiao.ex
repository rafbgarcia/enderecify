defmodule StatesApiWeb.Graphql.Type.Regiao do
  use StatesApiWeb, :graphql_schema

  object :regiao do
    field(:nome, :string)
    field(:sigla, :string)
  end
end
