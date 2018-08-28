defmodule StatesApiWeb.Graphql.Schema do
  use Absinthe.Schema

  import_types(StatesApiWeb.Graphql.Types)

  query do
    field :regioes, list_of(:regiao) do
      resolve(&StatesApi.Resolve.Regiao.handle/2)
    end

    field :estados, list_of(:estado) do
      arg(:sigla, :sigla)
      arg(:sigla_regiao, :string)
      resolve(&StatesApi.Resolve.Estado.handle/2)
    end
  end
end
