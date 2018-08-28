defmodule StatesApi.CPC do
  use StatesApiWeb, :schema
  alias StatesApi.{Estado, Localidade}

  schema "cpcs" do
    belongs_to(:estado, Estado, foreign_key: :sigla_estado, references: :sigla, type: :string)
    belongs_to(:localidade, Localidade)
    field :nome, :string
    field :endereco, :string
    field :cep, :string
  end

  @doc false
  def new(attrs) do
    %StatesApi.CPC{}
    |> cast(attrs, [:id, :localidade_id, :sigla_estado, :nome, :endereco, :cep])
  end
end
