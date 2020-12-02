defmodule ReadInput do
  def read_input(name) do
    name
    |> File.stream!()
    |> Stream.map(&String.trim(&1))
    |> Enum.to_list()
  end
end
