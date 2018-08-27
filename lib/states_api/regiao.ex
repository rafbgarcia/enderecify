defmodule StatesApi.Regiao do
  use StatesApiWeb, :schema

  schema "regioes" do
    field :sigla, :string
    field :nome, :string
  end

  @doc false
  def changeset(regiao, attrs) do
    regiao
    |> cast(attrs, [:sigla, :nome])
  end
end
