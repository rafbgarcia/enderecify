defmodule StatesApiWeb.Graphql.Type.Localidade do
  use StatesApiWeb, :graphql_schema

  object :localidade do
    field(:id, :id)
    field(:nome, :string)
    # field(:cep, :string)
    # field(:situacao, :string, description: """
    #   Situação da localidade:
    #   0 = não codificada em nível de Logradouro,
    #   1 = Localidade codificada em nível de Logradouro,
    #   2 = Distrito ou Povoado inserido na codificação em nível de Logradouro.
    # """)
    # field(:tipo, :string, description: """
    #   Tipo de localidade:
    #   D – Distrito,
    #   M – Município,
    #   P – Povoado
    # """)
    field(:abbr, :string, description: "Abreviação. Ex: Santa Fé - Sta Fé, Vila Flor - Vl Flor")
    field(:ibge_municipio_id, :string, description: "ID do município na API do IBGE. Ex: 1200351 - https://servicodados.ibge.gov.br/api/v1/localidades/municipios/1200351")
    # field(:estado, :estado, resolve: assoc(:estado))
    # field(:bairros, list_of(:bairro), resolve: assoc(:bairros, fn(query, _args, _ctx) ->
    #   query |> order_by(:nome)
    # end))
  end
end
