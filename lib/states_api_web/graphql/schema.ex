defmodule StatesApiWeb.Graphql.Schema do
  use Absinthe.Schema

  import_types(StatesApiWeb.Graphql.Types)

  query do
    field :regioes, list_of(:regiao), resolve: &StatesApi.Resolve.Regiao.handle/2
  end
end
