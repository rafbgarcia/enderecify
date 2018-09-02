defmodule StatesApi.Repo.LogradouroSearch do
  require Logger
  alias StatesApi.{Repo, Logradouro, Estado, Bairro, Localidade, LogradouroSearch, Helpers}

  def run do
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
    logradouros = Logradouro |> Repo.all()

    Logger.info ">>> Inserting Logradouros Search..."
    logradouros
    |> Enum.chunk_every(30_000)
    |> Enum.reduce([], fn(batch, array) ->
      task = Task.async(fn -> reduce_batch(batch, estados, localidades, bairros) end)
      [task | array]
    end)
    |> Enum.flat_map(&(Task.await(&1, 60 * 60 * 1000)))
    |> Enum.chunk_every(7_000)
    |> Enum.each(fn(batch) ->
      Logger.info ">>> Inserting #{length batch} batch"
      Repo.insert_all(LogradouroSearch, batch)
    end)
  end

  defp reduce_batch(logradouros, estados, localidades, bairros) do
    Logger.info ">>> Mapping #{length logradouros} logradouros"

    logradouros
    |> Enum.map(&(derive_search(&1, estados, localidades, bairros)))
  end

  defp derive_search(logradouro, estados, localidades, bairros) do
    estado = estados[logradouro.sigla_estado]
    bairro = bairros[logradouro.bairro_id]
    localidade = localidades[logradouro.localidade_id]

    LogradouroSearch.new(%{
      sigla_estado: estado.sigla,
      localidade_id: localidade.id,
      table_name: "logradouros",
      record_id: logradouro.id,
      endereco: build_address(logradouro, bairro, localidade, estado)
    }).changes
  end

  defp build_address(logradouro, bairro, localidade, estado) do
    [
      logradouro.tipo,
      logradouro.nome,
      bairro.nome,
      localidade.nome,
      estado.nome,
      estado.sigla,
    ]
    |> Enum.reject(&(is_nil(&1)))
    |> Enum.join(" ")
    |> Helpers.normalize_address()
  end
end

StatesApi.Repo.LogradouroSearch.run()
