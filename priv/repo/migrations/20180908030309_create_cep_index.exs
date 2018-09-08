defmodule StatesApi.Repo.Migrations.CreateCepIndex do
  use Ecto.Migration

  def change do
    create index(:logradouros, [:cep])
  end
end
