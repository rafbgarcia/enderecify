defmodule StatesApi.Repo.Migrations.CreateBairrosIndexOnLocalidadeId do
  use Ecto.Migration

  def change do
    create index(:bairros, [:localidade_id])
  end
end
