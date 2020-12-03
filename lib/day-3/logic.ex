defmodule Advent.Day3 do
  @day_no "3"

  def run do
    IO.puts("Starting day #{@day_no} logic\n")

    # input = ReadInput.read_input("lib/day-#{@day_no}/test-input")

    input = ReadInput.read_input("lib/day-#{@day_no}/input")

    part1(input)
    part2(input)

    IO.puts("\nDay #{@day_no} logic finished")
  end

  defp part1(input) do
    IO.puts("\n Part 1:\n")

    movement = {3, 1}
    score = 0

    res = move({input, movement, movement, score}, true)

    IO.inspect(res, label: "Score")
  end

  defp part2(input) do
    IO.puts("\n Part 2:\n")

    movements = [{1, 1}, {3, 1}, {5, 1}, {7, 1}, {1, 2}]

    res =
      Enum.reduce([1] ++ movements, fn el, acc ->
        score = 0
        res = move({input, el, el, score}, true)

        IO.inspect(res, label: "Current score")

        acc * res
      end)

    IO.inspect(res, label: "Score")
  end

  defp get_coords(map, x, y) do
    size = String.length(Enum.at(map, 0))
    overflow = x - div(x, size) * size

    map |> Enum.at(y) |> String.at(overflow)
  end

  defp move(args, true) do
    {map, {x, y}, movement, score} = args
    {move_x, move_y} = movement

    element = get_coords(map, x, y)
    new_score = if element == "#", do: score + 1, else: score

    {new_x, new_y} = {x + move_x, y + move_y}
    new_args = {map, {new_x, new_y}, movement, new_score}

    can_move? = new_y <= length(map) - 1
    move(new_args, can_move?)
  end

  defp move({_, _, _, score}, false), do: score
end
