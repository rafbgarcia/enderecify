defmodule StatesApi.Estado do
  use StatesApiWeb, :schema


  schema "estados" do
    belongs_to(:regiao, Region, foreign_key: :sigla_regiao, type: :string)
    field :sigla, :string
    field :nome, :string
  end

  @doc false
  def changeset(order, attrs) do
    order
    |> cast(attrs, [:sigla, :nome, :sigla_regiao])
  end
end
