defmodule StatesApiWeb.Graphql.Types do
  use Absinthe.Schema.Notation

  import_types(StatesApiWeb.Graphql.Type.Regiao)
  import_types(StatesApiWeb.Graphql.Type.Pharmacy)
  import_types(StatesApiWeb.Graphql.Type.Order)
end
