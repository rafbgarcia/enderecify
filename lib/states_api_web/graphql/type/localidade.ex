defmodule StatesApiWeb.Graphql.Type.Localidade do
  use StatesApiWeb, :graphql_schema

  object :localidade do
    field(:nome, :string)
    field(:sigla, :string)
  end
end
