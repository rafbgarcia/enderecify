defmodule StatesApiWeb.Graphql.Type.Bairro do
  use StatesApiWeb, :graphql_schema

  object :bairro do
    field(:id, :id)
    field(:nome, :string)
    field(:abbr, :string)
  end
end
