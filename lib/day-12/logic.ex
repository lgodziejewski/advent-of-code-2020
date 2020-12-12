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
    |> get_result1()
    |> calc_manhattan_distance()
    |> IO.inspect(label: "Result")
  end

  defp get_result1({coords, _}) do
    coords
  end

  defp part2(instructions) do
    IO.puts("\n Part 2:\n")

    initial_state = %{ship_coords: {0, 0}, waypoint_pos: {10, 1}}

    instructions
    |> Enum.reduce(initial_state, fn el, acc ->
      {instruction, value} = el

      move_part2(instruction, value, acc)
    end)
    |> get_result2()
    |> calc_manhattan_distance()
    |> IO.inspect(label: "Result")
  end

  defp get_result2(%{ship_coords: coords}) do
    coords
  end

  # ------- PART 1 ---------

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

  # ----------- PART 2 --------------

  # Action N means to move the waypoint north by the given value.
  # Action S means to move the waypoint south by the given value.
  # Action E means to move the waypoint east by the given value.
  # Action W means to move the waypoint west by the given value.
  # Action L means to rotate the waypoint around the ship left (counter-clockwise) the given number of degrees.
  # Action R means to rotate the waypoint around the ship right (clockwise) the given number of degrees.
  # Action F means to move forward to the waypoint a number of times equal to the given value.

  defp move_part2("F", value, current_state) do
    %{ship_coords: ship_coords, waypoint_pos: waypoint_pos} = current_state
    {d_x, d_y} = waypoint_pos
    {x, y} = ship_coords

    new_ship_coords = {x + d_x * value, y + d_y * value}

    %{ship_coords: new_ship_coords, waypoint_pos: waypoint_pos}
  end

  defp move_part2(instr, value, current_state) when instr in ["L", "R"] do
    %{ship_coords: ship_coords, waypoint_pos: waypoint_pos} = current_state

    {x, y} = waypoint_pos

    d_rotation =
      case instr do
        "L" -> value
        "R" -> -value
      end
      |> deg_to_radians()

    current_rotation = :math.atan2(y, x)
    distance = :math.sqrt(:math.pow(x, 2) + :math.pow(y, 2))

    new_rotation = current_rotation + d_rotation
    new_x = (distance * :math.cos(new_rotation)) |> round()
    new_y = (distance * :math.sin(new_rotation)) |> round()

    %{ship_coords: ship_coords, waypoint_pos: {new_x, new_y}}
  end

  # covers N, S, E, W
  defp move_part2(instr, value, current_state) do
    %{ship_coords: ship_coords, waypoint_pos: waypoint_pos} = current_state

    {x, y} = waypoint_pos

    new_waypoint_pos =
      case instr do
        "E" -> {x + value, y}
        "W" -> {x - value, y}
        "N" -> {x, y + value}
        "S" -> {x, y - value}
      end

    %{ship_coords: ship_coords, waypoint_pos: new_waypoint_pos}
  end

  defp deg_to_radians(deg) do
    deg * :math.pi() / 180
  end

  defp calc_manhattan_distance({x, y}) do
    abs(x) + abs(y)
  end
end
