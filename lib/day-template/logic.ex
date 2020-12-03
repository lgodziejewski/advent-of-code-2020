defmodule Advent.DayTemplate do
  @day_no "X"

  def run do
    IO.puts("Starting day #{@day_no} logic\n")

    # input = ReadInput.read_input("lib/day-#{@day_no}/input")
    input = ReadInput.read_input("lib/day-#{@day_no}/test-input")

    part1(input)
    part2(input)

    IO.puts("\nDay #{@day_no} logic finished")
  end

  defp part1(input) do
    IO.puts("\n Part 1:\n")
  end

  defp part2(input) do
    IO.puts("\n Part 2:\n")
  end
end
