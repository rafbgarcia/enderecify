defmodule StatesApi.LogradouroSearch do
  use StatesApiWeb, :schema
  alias StatesApi.{Localidade, Estado}

  schema "logradouros_search" do
    belongs_to(:localidade, Localidade)
    belongs_to(:estado, Estado, foreign_key: :sigla_estado, references: :sigla, type: :string)
    field(:endereco, :string)
    field(:readings, {:array, :string})
    field(:table_name, :string)
    field(:record_id, :integer)
  end

  @doc false
  def new(attrs) do
    %StatesApi.LogradouroSearch{}
    |> cast(attrs, [:localidade_id, :sigla_estado, :endereco, :readings, :table_name, :record_id])
  end
end
