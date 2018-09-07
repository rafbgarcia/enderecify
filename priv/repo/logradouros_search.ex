defmodule StatesApi.Repo.LogradouroSearch do
  require Logger
  alias StatesApi.{Repo, Logradouro, Estado, Bairro, Localidade, LogradouroSearch, Helpers}

  def run do
    Logger.info ">>> Deleting records"
    delete_all()
    insert()
  end

  defp delete_all do
    Repo.delete_all(LogradouroSearch)
  end

  defp insert do
    Logger.info ">>> Fetching and Mapping dependencies..."
    estados = Repo.all(Estado) |> Enum.into(%{}, &({&1.sigla, &1}))
    bairros = Repo.all(Bairro) |> Enum.into(%{}, &({&1.id, &1}))
    localidades = Repo.all(Localidade) |> Enum.into(%{}, &({&1.id, &1}))

    Logger.info ">>> Fetching more than 1M logradouros..."
    logradouros = Logradouro |> Repo.stream()

    Repo.transaction(fn ->
      logradouros
      |> Stream.chunk_every(10_000)
      |> Stream.with_index()
      |> Enum.each(fn({batch, i}) ->
        records = reduce_batch(batch, estados, localidades, bairros)
        Repo.insert_all(LogradouroSearch, records)
        Logger.info ">>> Inseridos ate agora: #{length(batch) * (i+1)} logradouros"
        Logger.info ">>> Faltam aprox.: #{1_030_000 - length(batch) * (i+1)} logradouros"
      end)
    end, timeout: :infinity)
  end

  defp reduce_batch(logradouros, estados, localidades, bairros) do
    logradouros
    |> Enum.map(&(derive_search(&1, estados, localidades, bairros)))
  end

  defp derive_search(logradouro, estados, localidades, bairros) do
    estado = estados[logradouro.sigla_estado]
    bairro = bairros[logradouro.bairro_id]
    localidade = localidades[logradouro.localidade_id]

    %{
      sigla_estado: estado.sigla,
      localidade_id: localidade.id,
      table_name: "logradouros",
      record_id: logradouro.id,
      endereco: build_address(logradouro, bairro, localidade, estado),
      readings: build_readings(logradouro, bairro, localidade, estado)
    }
  end

  defp build_address(logradouro, bairro, localidade, estado) do
    "#{logradouro.tipo} #{logradouro.nome} #{bairro.nome} #{localidade.nome} #{estado.nome} #{estado.sigla}"
  end

  def build_readings(logradouro, bairro, localidade, estado) do
    nomes = [logradouro.nome, logradouro.abbr, "#{logradouro.tipo} #{logradouro.nome}"] |> Enum.map(&Helpers.normalize_address/1)
    bairros = [bairro.nome, bairro.abbr] |> Enum.map(&Helpers.normalize_address/1)
    localidades = [localidade.nome, localidade.abbr] |> Enum.map(&Helpers.normalize_address/1)
    estados = [estado.nome, estado.sigla] |> Enum.map(&Helpers.normalize_address/1)

    nomes
    |> aggregate(bairros)
    |> aggregate(localidades)
    |> aggregate(estados)
  end

  defp aggregate(base, aggregations) do
    l = Enum.flat_map(base, fn(base_text) ->
      Enum.map(aggregations, &("#{base_text} #{&1}"))
    end)
    |> MapSet.new()
    |> MapSet.to_list()
    base ++ l
  end
end

StatesApi.Repo.LogradouroSearch.run()
