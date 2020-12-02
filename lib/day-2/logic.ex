defmodule Advent.Day2 do
  @day_no "2"

  def run do
    IO.puts("Starting day #{@day_no} logic\n")

    input = ReadInput.read_input("lib/day-#{@day_no}/input")

    part1(input)
    part2(input)

    IO.puts("\nDay #{@day_no} logic finished")
  end

  defp part1(input) do
    IO.puts("\n Part 1:\n")

    res =
      Enum.reduce([0] ++ input, fn el, acc ->
        [policy, password] = String.split(el, ": ")
        [range, letter] = String.split(policy, " ")
        [min, max] = String.split(range, "-") |> Enum.map(&String.to_integer(&1))

        password_cut = String.replace(password, letter, "")
        letter_count = String.length(password) - String.length(password_cut)

        if letter_count >= min and letter_count <= max do
          acc + 1
        else
          acc
        end
      end)

    IO.inspect(res)
  end

  defp part2(input) do
    IO.puts("\n Part 2:\n")

    res2 =
      Enum.reduce([0] ++ input, fn el, acc ->
        [policy, password] = String.split(el, ": ")
        [range, letter] = String.split(policy, " ")
        [first_pos, second_pos] = String.split(range, "-") |> Enum.map(&String.to_integer(&1))

        first_match = if String.at(password, first_pos - 1) == letter, do: 1, else: 0
        second_match = if String.at(password, second_pos - 1) == letter, do: 1, else: 0

        if first_match + second_match == 1 do
          acc + 1
        else
          acc
        end
      end)

    IO.inspect(res2)
  end
end
