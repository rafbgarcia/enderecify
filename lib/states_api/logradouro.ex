defmodule StatesApi.Logradouro do
  use StatesApiWeb, :schema
  alias StatesApi.{Estado, Localidade, Bairro}

  schema "logradouros" do
    belongs_to(:estado, Estado, foreign_key: :sigla_estado, references: :sigla, type: :string)
    belongs_to(:localidade, Localidade)
    belongs_to(:bairro, Bairro)
    field :nome, :string
    field :complemento, :string
    field :cep, :string
    field :tipo, :string
    field :utilizacao, :string
    field :abbr, :string
  end

  @doc false
  def new(attrs) do
    %StatesApi.Logradouro{}
    |> cast(attrs, [:id, :localidade_id, :sigla_estado, :bairro_id, :nome, :complemento, :cep, :tipo, :utilizacao, :abbr])
  end
end
