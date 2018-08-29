defmodule StatesApiWeb.Graphql.Type.Bairro do
  use StatesApiWeb, :graphql_schema

  object :bairro do
    field(:nome, :string)
  end
end
