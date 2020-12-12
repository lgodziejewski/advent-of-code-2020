defmodule Advent.Day12 do
  @day_no "12"

  def run do
    IO.puts("Starting day #{@day_no} logic\n")

    # ReadInput.read_input("lib/day-#{@day_no}/test-input")
    input =
      ReadInput.read_input("lib/day-#{@day_no}/input")
      |> parse_instructions()

    part1(input)
    part2(input)

    IO.puts("\nDay #{@day_no} logic finished")
  end

  def parse_instructions(input) do
    input
    |> Enum.map(fn el ->
      {instruction, value_str} = String.split_at(el, 1)
      value = String.to_integer(value_str)

      {instruction, value}
    end)
  end

  defp part1(instructions) do
    IO.puts("\n Part 1:\n")

    initial_state = {{0, 0}, 0}

    instructions
    |> Enum.reduce(initial_state, fn el, acc ->
      {instruction, value} = el

      move(instruction, value, acc)
    end)
    |> calc_manhattan_distance()
    |> IO.inspect(label: "Result")
  end

  defp part2(input) do
    IO.puts("\n Part 2:\n")
  end

  defp move("F", value, current_state) do
    {coords, rotation} = current_state
    {x, y} = coords

    # 0 means east, 90 north, 180 west, 270 south
    new_coords =
      case rotation do
        0 -> {x + value, y}
        90 -> {x, y + value}
        180 -> {x - value, y}
        270 -> {x, y - value}
      end

    {new_coords, rotation}
  end

  defp move(instr, value, current_state) when instr in ["L", "R"] do
    {coords, rotation} = current_state

    new_rotation =
      case instr do
        "L" -> rotation + value
        "R" -> rotation - value
      end
      |> Integer.mod(360)

    {coords, new_rotation}
  end

  # covers N, S, E, W
  defp move(instr, value, current_state) do
    {coords, rotation} = current_state
    {x, y} = coords

    new_coords =
      case instr do
        "E" -> {x + value, y}
        "W" -> {x - value, y}
        "N" -> {x, y + value}
        "S" -> {x, y - value}
      end

    {new_coords, rotation}
  end

  defp calc_manhattan_distance({coords, _}) do
    {x, y} = coords

    abs(x) + abs(y)
  end
end
