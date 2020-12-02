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

    try do
      Enum.find(input, fn el1 ->
        res_2 = Enum.find(input, fn el2 -> el1 + el2 == 2020 end)

        case res_2 do
          nil ->
            false

          _ ->
            IO.inspect(el1, label: "First number")
            IO.inspect(res_2, label: "Second number")
            throw(el1 * res_2)
        end
      end)
    catch
      result -> IO.inspect(result, label: "Result")
    end
  end

  defp part2(input) do
    IO.puts("\n Part 2:\n")

    try do
      Enum.each(input, fn el1 ->
        Enum.each(input, fn el2 ->
          res_3 = Enum.find(input, fn el3 -> el1 + el2 + el3 == 2020 end)

          case res_3 do
            nil ->
              false

            _ ->
              IO.inspect(el1, label: "First number")
              IO.inspect(el2, label: "Second number")
              IO.inspect(res_3, label: "Third number")
              throw(el1 * el2 * res_3)
          end
        end)
      end)
    catch
      result -> IO.inspect(result, label: "Result")
    end
  end
end
