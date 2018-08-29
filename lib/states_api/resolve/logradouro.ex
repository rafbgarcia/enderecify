defmodule StatesApi.Resolve.Logradouro do
  use StatesApiWeb, :graphql_resolver
  alias StatesApi.Logradouro

  def handle(%{cep: cep}, _) do
    {
      :ok,
      with_cep(cep) |> by_nome() |> Repo.all()
    }
  end

  # return Ex: Rua Nome Da Rua, Centro
  def linha1(logradouro, _args, _ctx) do
    bairro = bairro(logradouro).nome

    {
      :ok,
      [
        [logradouro.tipo, logradouro.nome] |> join_address(" "),
        logradouro.complemento,
        bairro
      ] |> join_address()
    }
  end

  # return Ex: 45678-910, Cidade, Estado
  def linha2(logradouro, _args, _ctx) do
    localidade = localidade(logradouro)

    {
      :ok,
      [formatted_cep(logradouro.cep), localidade.nome, localidade.sigla_estado]
      |> join_address()
    }
  end

  def formatted_cep(logradouro, _args, _ctx) do
    {:ok, formatted_cep(logradouro.cep)}
  end

  defp formatted_cep(cep) do
    cep
    |> String.graphemes()
    |> List.insert_at(5, "-")
    |> Enum.join()
  end

  defp with_cep(query \\ Logradouro, cep) do
    digits = cep |> String.replace(~r/[^\d]/, "")

    query |> where(cep: ^digits)
  end

  defp by_nome(query \\ Logradouro) do
    query |> order_by(:nome)
  end

  defp bairro(logradouro) do
    Repo.preload(logradouro, :bairro).bairro
  end

  defp localidade(logradouro) do
    Repo.preload(logradouro, :localidade).localidade
  end

  defp join_address(array, join_with \\ ", ") do
    array
    |> Enum.reject(&(is_nil(&1)))
    |> Enum.join(join_with)
  end
end
