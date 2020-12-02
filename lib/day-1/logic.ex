defmodule Advent.Day1 do
  @day_no "1"

  def run do
    IO.puts("Starting day #{@day_no} logic\n")

    input = ReadInput.read_input("lib/day-#{@day_no}/input") |> Enum.map(&String.to_integer(&1))

    part1(input)
    part2(input)

    IO.puts("\nDay #{@day_no} logic finished")
  end

  defp part1(input) do
    IO.puts("\n Part 1:\n")

    sum = 2020
    numbers_map = Map.new(input, fn el -> {el, true} end)

    num1 = Enum.find(input, fn el -> Map.get(numbers_map, sum - el, false) end)
    num2 = sum - num1

    IO.inspect(num1, label: "First number")
    IO.inspect(num2, label: "Second number")
    IO.inspect(num1 * num2, label: "Result")
  end

  defp part2(input) do
    IO.puts("\n Part 2:\n")

    sum = 2020
    numbers_map = Map.new(input, fn el -> {el, true} end)

    try do
      Enum.each(input, fn el1 ->
        res_2 = Enum.find(input, fn el2 -> Map.get(numbers_map, sum - el1 - el2, false) end)

        case res_2 do
          nil ->
            false

          _ ->
            el3 = sum - el1 - res_2
            throw({el1, res_2, el3})
        end
      end)
    catch
      {num1, num2, num3} ->
        result = num1 * num2 * num3
        IO.inspect(num1, label: "First number")
        IO.inspect(num2, label: "Second number")
        IO.inspect(num3, label: "Third number")
        IO.inspect(result, label: "Result")
    end
  end
end
