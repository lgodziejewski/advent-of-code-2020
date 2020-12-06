defmodule Advent.Day6 do
  @day_no "6"

  def run do
    IO.puts("Starting day #{@day_no} logic\n")

    # input = ReadInput.read_input("lib/day-#{@day_no}/test-input")
    input = ReadInput.read_input("lib/day-#{@day_no}/input")

    grouped_data = parse_group(input)

    part1(grouped_data)
    part2(grouped_data)

    IO.puts("\nDay #{@day_no} logic finished")
  end

  defp part1(input) do
    IO.puts("\n Part 1:\n")

    input
    |> Enum.reduce(0, fn el, acc ->
      unique_elements =
        el
        |> String.replace(" ", "")
        |> String.split("")
        |> Enum.filter(&(&1 !== ""))
        |> MapSet.new()
        |> MapSet.size()

      acc + unique_elements
    end)
    |> IO.inspect()
  end

  defp part2(input) do
    IO.puts("\n Part 2:\n")

    input
    |> Enum.reduce(0, fn el, acc ->
      common_elements =
        el
        |> String.split(" ")
        |> Enum.map(fn entry ->
          entry
          |> String.split("")
          |> Enum.filter(&(&1 !== ""))
          |> MapSet.new()
        end)
        |> Enum.reduce(fn el, acc ->
          MapSet.intersection(acc, el)
        end)
        |> MapSet.size()

      acc + common_elements
    end)
    |> IO.inspect()
  end

  defp parse_group(input) do
    input
    |> Enum.chunk_by(fn el -> el == "" end)
    |> Enum.map(&Enum.join(&1, " "))
    |> Enum.filter(&(&1 !== ""))
  end
end
