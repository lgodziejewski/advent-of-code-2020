defmodule Advent.Day10 do
  @day_no "10"

  def run do
    IO.puts("Starting day #{@day_no} logic\n")

    # ReadInput.read_input("lib/day-#{@day_no}/test-input")
    # ReadInput.read_input("lib/day-#{@day_no}/test-input-2")
    input =
      ReadInput.read_input("lib/day-#{@day_no}/input")
      |> Enum.map(&String.to_integer/1)

    sorted_list = Enum.sort(input)

    part1(sorted_list)
    part2(input)

    IO.puts("\nDay #{@day_no} logic finished")
  end

  defp part1(input) do
    IO.puts("\n Part 1:\n")

    %{1 => ones, 3 => threes} =
      input
      |> Enum.reduce(%{1 => 0, 2 => 0, 3 => 1, prev: 0}, fn el, acc ->
        %{prev: prev} = acc
        diff = el - prev
        new_count = Map.get(acc, diff) + 1

        acc
        |> put_in([:prev], el)
        |> put_in([diff], new_count)
      end)

    IO.inspect(ones * threes, label: "Result")
  end

  defp part2(input) do
    IO.puts("\n Part 2:\n")
  end
end
