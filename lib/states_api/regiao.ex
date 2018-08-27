defmodule StatesApi.Regiao do
  use StatesApiWeb, :schema

  schema "regioes" do
    field :sigla, :string
    field :nome, :string
  end

  @doc false
  def new(attrs) do
    %StatesApi.Regiao{}
    |> cast(attrs, [:sigla, :nome])
  end
end
