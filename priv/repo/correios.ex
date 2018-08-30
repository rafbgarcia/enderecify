# Module is run at the end of this file

defmodule StatesApi.Repo.Correios do
  require Logger

  alias StatesApi.{Repo, Regiao, Estado, Bairro, Localidade, CPC, Logradouro}

  @insert_limit_for_testing 100

  def insert_data do
    sanitize_file_names()

    insert_regioes()
    insert_estados()
    insert_localidades()
    insert_bairros()
    insert_cpcs()
    insert_logradouros()
  end

  defp insert_regioes do
    regioes = [%{id: 1,sigla: "N",nome: "Norte"},%{id: 2,sigla: "NE",nome: "Nordeste"},%{id: 3,sigla: "SE",nome: "Sudeste"},%{id: 4,sigla: "S",nome: "Sul"},%{id: 5,sigla: "CO",nome: "Centro-Oeste"}]
    records = Enum.map(regioes, fn(regiao) -> Regiao.new(regiao).changes end)

    bulk_insert(Regiao, records)
  end

  defp insert_estados do
    estados = Enum.map(ibge_states(), fn(state) ->
      Estado.new(%{
        sigla: state.sigla,
        nome: state.nome,
        sigla_regiao: state.regiao.sigla,
      }).changes
    end)

    bulk_insert(Estado, estados)
  end

  defp insert_localidades do
    localidades = map_file("LOG_LOCALIDADE", fn(line) ->
      [id, sigla_estado, nome, cep, situacao, tipo, _localidade_subordinacao, abbr, ibge_municipio_id] = line

      Localidade.new(%{
        id: id,
        sigla_estado: sigla_estado,
        nome: nome,
        cep: cep,
        situacao: situacao,
        tipo: tipo,
        abbr: abbr,
        ibge_municipio_id: ibge_municipio_id,
      }).changes
    end)

    bulk_insert(Localidade, localidades)
  end

  defp insert_bairros do
    bairros = map_file("LOG_BAIRRO", fn(line) ->
      [id, sigla_estado, localidade_id, nome, abbr] = line

      Bairro.new(%{
        id: id,
        sigla_estado: sigla_estado,
        localidade_id: localidade_id,
        nome: nome,
        abbr: abbr,
      }).changes
    end)

    bulk_insert(Bairro, bairros)
  end

  defp insert_cpcs do
    records = map_file("LOG_CPC", fn(line) ->
      [id, sigla_estado, localidade_id, nome, endereco, cep] = line

      CPC.new(%{
        id: id,
        sigla_estado: sigla_estado,
        localidade_id: localidade_id,
        nome: nome,
        endereco: endereco,
        cep: cep,
      }).changes
    end)

    bulk_insert(CPC, records)
  end

  defp insert_logradouros do
    records = Enum.reduce(ibge_states(), [], fn(%{sigla: uf}, array) ->
      result = Task.async(fn ->
        Logger.info ">>> MAPPING LOG_LOGRADOURO_#{uf}"

        logradouros = map_file("LOG_LOGRADOURO_#{uf}", fn(line) ->
          [id, sigla_estado, localidade_id, bairro_id, _bairro_fim, nome, complemento, cep, tipo, utilizacao, abbr] = line

          Logradouro.new(%{
            id: id,
            sigla_estado: sigla_estado,
            localidade_id: localidade_id,
            bairro_id: bairro_id,
            nome: nome,
            complemento: complemento,
            cep: cep,
            tipo: tipo,
            utilizacao: utilizacao,
            abbr: abbr,
          }).changes
        end)

        Logger.info ">>> INSERTING LOG_LOGRADOURO_#{uf}"
        bulk_insert(Logradouro, logradouros, 5_000)
      end)

      [result | array]
    end)

    records
    |> Enum.flat_map(&(Task.await(&1, 60 * 60 * 1000)))
  end

  defp bulk_insert(schema, records, batch_size \\ 7_000) do
    records
    |> Enum.chunk_every(batch_size)
    |> Enum.each(fn(batch) ->
      Repo.insert_all(schema, batch)
    end)

    records
  end

  defp map_file(filename, callback) do
    Path.expand("priv/repo/Correios/#{filename}.TXT")
    |> File.stream!()
    |> Enum.map(fn(line) ->
      String.split(line, "@")
      |> Enum.map(&to_utf8/1)
      |> callback.()
    end)
  end

  defp to_utf8(string) do
    :unicode.characters_to_binary(string, :latin1)
    |> sanitize_string()
  end

  defp sanitize_string(string) do
    string
    |> String.trim()
  end

  defp ibge_states do
    [%{id: 11,sigla: "RO",nome: "Rondônia",regiao: %{id: 1,sigla: "N",nome: "Norte"}}, %{id: 12,sigla: "AC",nome: "Acre",regiao: %{id: 1,sigla: "N",nome: "Norte"}}, %{id: 13,sigla: "AM",nome: "Amazonas",regiao: %{id: 1,sigla: "N",nome: "Norte"}}, %{id: 14,sigla: "RR",nome: "Roraima",regiao: %{id: 1,sigla: "N",nome: "Norte"}}, %{id: 15,sigla: "PA",nome: "Pará",regiao: %{id: 1,sigla: "N",nome: "Norte"}}, %{id: 16,sigla: "AP",nome: "Amapá",regiao: %{id: 1,sigla: "N",nome: "Norte"}}, %{id: 17,sigla: "TO",nome: "Tocantins",regiao: %{id: 1,sigla: "N",nome: "Norte"}}, %{id: 21,sigla: "MA",nome: "Maranhão",regiao: %{id: 2,sigla: "NE",nome: "Nordeste"}}, %{id: 22,sigla: "PI",nome: "Piauí",regiao: %{id: 2,sigla: "NE",nome: "Nordeste"}}, %{id: 23,sigla: "CE",nome: "Ceará",regiao: %{id: 2,sigla: "NE",nome: "Nordeste"}}, %{id: 24,sigla: "RN",nome: "Rio Grande do Norte",regiao: %{id: 2,sigla: "NE",nome: "Nordeste"}}, %{id: 25,sigla: "PB",nome: "Paraíba",regiao: %{id: 2,sigla: "NE",nome: "Nordeste"}}, %{id: 26,sigla: "PE",nome: "Pernambuco",regiao: %{id: 2,sigla: "NE",nome: "Nordeste"}}, %{id: 27,sigla: "AL",nome: "Alagoas",regiao: %{id: 2,sigla: "NE",nome: "Nordeste"}}, %{id: 28,sigla: "SE",nome: "Sergipe",regiao: %{id: 2,sigla: "NE",nome: "Nordeste"}}, %{id: 29,sigla: "BA",nome: "Bahia",regiao: %{id: 2,sigla: "NE",nome: "Nordeste"}}, %{id: 31,sigla: "MG",nome: "Minas Gerais",regiao: %{id: 3,sigla: "SE",nome: "Sudeste"}}, %{id: 32,sigla: "ES",nome: "Espírito Santo",regiao: %{id: 3,sigla: "SE",nome: "Sudeste"}}, %{id: 33,sigla: "RJ",nome: "Rio de Janeiro",regiao: %{id: 3,sigla: "SE",nome: "Sudeste"}}, %{id: 35,sigla: "SP",nome: "São Paulo",regiao: %{id: 3,sigla: "SE",nome: "Sudeste"}}, %{id: 41,sigla: "PR",nome: "Paraná",regiao: %{id: 4,sigla: "S",nome: "Sul"}}, %{id: 42,sigla: "SC",nome: "Santa Catarina",regiao: %{id: 4,sigla: "S",nome: "Sul"}}, %{id: 43,sigla: "RS",nome: "Rio Grande do Sul",regiao: %{id: 4,sigla: "S",nome: "Sul"}}, %{id: 50,sigla: "MS",nome: "Mato Grosso do Sul",regiao: %{id: 5,sigla: "CO",nome: "Centro-Oeste"}}, %{id: 51,sigla: "MT",nome: "Mato Grosso",regiao: %{id: 5,sigla: "CO",nome: "Centro-Oeste"}}, %{id: 52,sigla: "GO",nome: "Goiás",regiao: %{id: 5,sigla: "CO",nome: "Centro-Oeste"}}, %{id: 53,sigla: "DF",nome: "Distrito Federal",regiao: %{id: 5,sigla: "CO",nome: "Centro-Oeste"}} ]
  end

  defp sanitize_file_names do
    dir = "priv/repo/Correios/"
    Path.expand(dir)
    |> File.ls!()
    |> Enum.filter(&(String.match?(&1, ~r/.txt$/i)))
    |> Enum.each(fn(filename) ->
      from = Path.expand(dir <> filename)
      to = Path.expand(dir <> String.upcase(filename))
      File.rename(from, to)
    end)
  end
end


StatesApi.Repo.Correios.insert_data()
