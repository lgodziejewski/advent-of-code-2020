defmodule Advent.Day4 do
  @day_no "4"

  def run do
    IO.puts("Starting day #{@day_no} logic\n")

    input = ReadInput.read_input("lib/day-#{@day_no}/input")

    # input = ReadInput.read_input("lib/day-#{@day_no}/test-input")

    passport_map = parse_input(input)

    part1(passport_map)
    part2(passport_map)

    IO.puts("\nDay #{@day_no} logic finished")
  end

  defp part1(input) do
    IO.puts("\n Part 1:\n")

    result =
      Enum.reduce(input, 0, fn el, acc ->
        if is_valid(el) do
          acc + 1
        else
          acc
        end
      end)

    IO.inspect(result, label: "Valid passports")
  end

  defp part2(input) do
    IO.puts("\n Part 2:\n")
  end

  defp parse_input(input) do
    input
    |> Enum.chunk_by(fn el -> el == "" end)
    |> Enum.map(&Enum.join(&1, " "))
    |> Enum.filter(&(&1 !== ""))
    |> Enum.map(&parse_row/1)
  end

  defp parse_row(row) do
    row
    |> String.split(" ")
    |> Enum.map(&String.split(&1, ":"))
    |> Map.new(fn [key, val] -> {key, val} end)
  end

  defp is_valid(entry) do
    Enum.all?(required_fields(), &Map.has_key?(entry, &1))
  end

  defp required_fields do
    ["byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid"]
  end

  defp optional_fields do
    ["cid"]
  end
end
