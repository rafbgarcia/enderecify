defmodule StatesApi.Repo.Migrations.CreateDb do
  use Ecto.Migration

  def change do
    create table(:regioes, primary_key: false) do
      add :sigla, :string, primary_key: true
      add :nome, :string
    end
    create unique_index(:regioes, [:sigla])

    create table(:estados, primary_key: false) do
      add :sigla, :string, primary_key: true
      add :sigla_regiao, references(:regioes, column: :sigla, type: :string, on_delete: :delete_all)
      add :nome, :string
    end
    create unique_index(:estados, [:sigla])

    create table(:cidades) do
      add :sigla_estado, references(:estados, column: :sigla, type: :string, on_delete: :delete_all)
      add :nome, :string
    end

    create table(:localidades) do
      add :sigla_estado, references(:estados, column: :sigla, type: :string, on_delete: :delete_all)
      add :nome, :string
      add :cep, :string
      add :situacao, :string
      add :tipo, :string
      add :abbr, :string
      add :ibge_municipio_id, :string # https://servicodados.ibge.gov.br/api/v1/localidades/municipios/1200351
    end

    create table(:bairros) do
      add :localidade_id, references(:localidades, on_delete: :delete_all)
      add :sigla_estado, references(:estados, column: :sigla, type: :string, on_delete: :delete_all)
      add :nome, :string
      add :abbr, :string
    end

    create table(:cpcs) do
      add :localidade_id, references(:localidades, on_delete: :delete_all)
      add :sigla_estado, references(:estados, column: :sigla, type: :string, on_delete: :delete_all)
      add :nome, :string
      add :endereco, :string
      add :cep, :string
    end

    create table(:logradouros) do
      add :localidade_id, references(:localidades, on_delete: :delete_all)
      add :sigla_estado, references(:estados, column: :sigla, type: :string, on_delete: :delete_all)
      add :bairro_id, references(:bairros, on_delete: :delete_all)
      add :nome, :string
      add :complemento, :string
      add :cep, :string
      add :tipo, :string
      add :utilizacao, :string
      add :abbr, :string
    end
  end
end
