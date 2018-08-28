defmodule StatesApi.Regiao do
  use StatesApiWeb, :schema
  alias StatesApi.{Estado}

  @primary_key {:sigla, :string, []}

  schema "regioes" do
    has_many :estados, Estado, foreign_key: :sigla_regiao
    field :nome, :string
  end

  @doc false
  def new(attrs) do
    %StatesApi.Regiao{}
    |> cast(attrs, [:sigla, :nome])
  end
end
