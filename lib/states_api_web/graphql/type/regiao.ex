defmodule StatesApiWeb.Graphql.Type.Regiao do
  use StatesApiWeb, :graphql_schema

  object :regiao do
    field(:nome, :string)
    field(:sigla, :string)
    field(:estados, list_of(:estado), resolve: assoc(:estados))
  end
end
