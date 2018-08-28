defmodule StatesApiWeb.Graphql.Types do
  use Absinthe.Schema.Notation

  import_types(StatesApiWeb.Graphql.Type.Regiao)
  import_types(StatesApiWeb.Graphql.Type.Estado)
  import_types(StatesApiWeb.Graphql.Type.Localidade)
end
