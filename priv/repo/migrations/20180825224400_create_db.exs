defmodule StatesApi.Repo.Migrations.CreateDb do
  use Ecto.Migration

  def change do
    create table(:regioes) do
      add :sigla, :string, primary_key: true
      add :nome, :string
    end
    create unique_index(:regioes, [:sigla])

    create table(:estados) do
      add :sigla, :string, primary_key: true
      add :sigla_regiao, references(:regioes, column: :sigla, type: :string, on_delete: :delete_all)
      add :nome, :string
    end
    create unique_index(:estados, [:sigla])

    create table(:cidades) do
      add :estado, references(:estados, column: :sigla, type: :string, on_delete: :delete_all)
      add :nome, :string
    end

    create table(:localidades) do
      add :uf, :string
      add :nome, :string
      add :cep, :string
      add :situacao, :string
      add :tipo, :string
      add :abbr, :string
      add :ibge_municipio_id, :integer # https://servicodados.ibge.gov.br/api/v1/localidades/municipios/1200351
    end

    create table(:bairros) do
      add :localidade_id, references(:localidades, on_delete: :delete_all)
      add :uf, :string
      add :nome, :string
      add :abbr, :string
    end
  end
end
