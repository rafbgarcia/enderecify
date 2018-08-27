defmodule StatesApi.Estado do
  use StatesApiWeb, :schema
  alias StatesApi.Regiao


  schema "estados" do
    belongs_to(:regiao, Regiao, foreign_key: :sigla_regiao, type: :string)
    field :sigla, :string
    field :nome, :string
  end

  @doc false
  def new(attrs) do
    %StatesApi.Estado{}
    |> cast(attrs, [:sigla, :nome, :sigla_regiao])
  end
end
