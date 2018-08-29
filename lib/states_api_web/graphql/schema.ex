defmodule StatesApiWeb.Graphql.Schema do
  use Absinthe.Schema

  import_types(StatesApiWeb.Graphql.Types)

  query do
    field :regioes, list_of(:regiao) do
      resolve(&StatesApi.Resolve.Regiao.handle/2)
    end

    field :estados, list_of(:estado) do
      arg(:sigla_regiao, :string)
      resolve(&StatesApi.Resolve.Estado.handle/2)
    end

    field :localidades, list_of(:localidade) do
      arg(:sigla_estado, non_null(:string))
      resolve(&StatesApi.Resolve.Localidade.handle/2)
    end

    field :bairros, list_of(:bairro) do
      arg(:localidade_id, non_null(:id))
      resolve(&StatesApi.Resolve.Bairro.handle/2)
    end
  end
end
