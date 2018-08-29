defmodule StatesApiWeb.Graphql.Types do
  use Absinthe.Schema.Notation

  import_types(StatesApiWeb.Graphql.Type.Regiao)
  import_types(StatesApiWeb.Graphql.Type.Estado)
  import_types(StatesApiWeb.Graphql.Type.Localidade)
  import_types(StatesApiWeb.Graphql.Type.Bairro)
  import_types(StatesApiWeb.Graphql.Type.Logradouro)
end
