defmodule StatesApi.Helpers do
  def normalize_address(string) do
    string
    |> String.downcase()
    |> String.normalize(:nfd)
    |> String.replace(~r/[^A-Za-z\s\d]/u, "")
  end
end
