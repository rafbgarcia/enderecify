defmodule StatesApiWeb.Graphql.Type.Logradouro do
  use StatesApiWeb, :graphql_schema

  object :logradouro do
    field(:estado, :estado, resolve: assoc(:estado))
    field(:localidade, :localidade, resolve: assoc(:localidade))
    field(:bairro, :bairro, resolve: assoc(:bairro))
    field(:nome, :string)
    field(:complemento, :string)
    field(:cep, :string)
    field(:tipo, :string, description: "Rua, Travessa, Avenida")
    field(:utilizacao, :string, description: "Indicador de utilização do tipo de logradouro (S ou N)")
    field(:abbr, :string)

    field(:formatted_cep, :string, resolve: &StatesApi.Resolve.Logradouro.formatted_cep/3)
    field(:linha1, :string, resolve: &StatesApi.Resolve.Logradouro.linha1/3)
    field(:linha2, :string, resolve: &StatesApi.Resolve.Logradouro.linha2/3)
  end
end
