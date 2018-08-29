defmodule StatesApi.Estado do
  use StatesApiWeb, :schema
  alias StatesApi.{Regiao, Localidade}

  @primary_key {:sigla, :string, []}

  schema "estados" do
    has_many(:cidades, Localidade, foreign_key: :sigla_estado)
    belongs_to(:regiao, Regiao, foreign_key: :sigla_regiao, references: :sigla, type: :string)
    field :nome, :string
  end

  @doc false
  def new(attrs) do
    %StatesApi.Estado{}
    |> cast(attrs, [:sigla, :nome, :sigla_regiao])
  end
end
