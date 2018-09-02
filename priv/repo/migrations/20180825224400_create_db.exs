defmodule StatesApi.Repo.Migrations.CreateDb do
  use Ecto.Migration

  def change do
    create_regioes()
    create_estados()
    create_localidades()
    create_bairros()
    create_cpcs()
    create_logradouros()
    create_logradouros_search()
  end

  defp create_regioes do
    create table(:regioes, primary_key: false) do
      add :sigla, :string, primary_key: true
      add :nome, :string
    end

    create unique_index(:regioes, [:sigla])
  end

  defp create_estados do
    create table(:estados, primary_key: false) do
      add :sigla, :string, primary_key: true
      add :sigla_regiao, references(:regioes, column: :sigla, type: :string, on_delete: :delete_all)
      add :nome, :string
    end

    create unique_index(:estados, [:sigla])
  end

  defp create_localidades do
    create table(:localidades) do
      add :sigla_estado, references(:estados, column: :sigla, type: :string, on_delete: :delete_all)
      add :nome, :string
      add :cep, :string
      add :situacao, :string
      add :tipo, :string
      add :abbr, :string
      add :ibge_municipio_id, :string # https://servicodados.ibge.gov.br/api/v1/localidades/municipios/1200351
    end
  end

  defp create_bairros do
    create table(:bairros) do
      add :localidade_id, references(:localidades, on_delete: :delete_all)
      add :sigla_estado, references(:estados, column: :sigla, type: :string, on_delete: :delete_all)
      add :nome, :string
      add :abbr, :string
    end
  end

  defp create_cpcs do
    create table(:cpcs) do
      add :localidade_id, references(:localidades, on_delete: :delete_all)
      add :sigla_estado, references(:estados, column: :sigla, type: :string, on_delete: :delete_all)
      add :nome, :string
      add :endereco, :string
      add :cep, :string
    end
  end

  defp create_logradouros do
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

  defp create_logradouros_search do
    execute "CREATE EXTENSION pgroonga"

    create table(:logradouros_search) do
      add :localidade_id, references(:localidades, on_delete: :delete_all), comment: "Usado para achar localidades de uma cidade"
      add :sigla_estado, references(:estados, column: :sigla, type: :string, on_delete: :delete_all), comment: "Usado para achar localidades de um estado"
      add :endereco, :text, comment: "Agrega todo o endereço para facilitar a busca. Ex: 'rua nova aurora natal rn'"
      add :table_name, :string, comment: "Tabela de referência do logradouro: `logradouro`, `grande_usuarios`, `unidades_operacionais`"
      add :record_id, :bigint, comment: "ID do registro na tabela de referência"
    end

    execute """
      CREATE INDEX pgroonga_logradouros_search_full_text_search
      ON logradouros_search
      USING pgroonga(endereco)
      WITH (tokenizer = 'TokenBigramSplitSymbolAlphaDigit');
    """
  end
end
