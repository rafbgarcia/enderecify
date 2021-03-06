defmodule StatesApi.Bairro do
  use StatesApiWeb, :schema
  alias StatesApi.{Estado, Localidade}

  schema "bairros" do
    belongs_to(:estado, Estado, foreign_key: :sigla_estado, references: :sigla, type: :string)
    belongs_to(:localidade, Localidade)
    field :nome, :string
    field :abbr, :string
  end

  @doc false
  def new(attrs) do
    %StatesApi.Bairro{}
    |> cast(attrs, [:id, :localidade_id, :sigla_estado, :nome, :abbr])
  end
end
