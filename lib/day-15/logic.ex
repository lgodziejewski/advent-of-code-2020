defmodule Advent.Day15 do
  @day_no "15"

  def run do
    IO.puts("Starting day #{@day_no} logic\n")

    # input = [0, 3, 6]
    # input = [2, 3, 1]
    input = [11, 0, 1, 10, 5, 19]

    part1(input)
    part2(input)

    IO.puts("\nDay #{@day_no} logic finished")
  end

  defp part1(input) do
    IO.puts("\n Part 1:\n")

    {initial_state, start_turn} = get_start_values(input)

    say_number(initial_state, 0, start_turn)
    |> IO.inspect(label: "Result")
  end

  defp part2(input) do
    IO.puts("\n Part 2:\n")

    {initial_state, start_turn} = get_start_values(input)

    say_number2(initial_state, 0, start_turn)
    |> IO.inspect(label: "Result")
  end

  defp get_start_values(input) do
    initial_state =
      input
      |> Enum.with_index(1)
      |> Map.new()

    start_turn = Enum.count(input) + 1
    {initial_state, start_turn}
  end

  defp say_number(_state, value, 2020), do: value

  defp say_number(state, value, turn) do
    {new_state, new_number} = common_logic(state, value, turn)
    say_number(new_state, new_number, turn + 1)
  end

  defp say_number2(_state, value, 30_000_000), do: value

  defp say_number2(state, value, turn) do
    {new_state, new_number} = common_logic(state, value, turn)
    say_number2(new_state, new_number, turn + 1)
  end

  defp common_logic(state, value, turn) do
    last_encounter = Map.get(state, value, 0)

    new_number = get_new_number(last_encounter, turn)
    new_state = Map.put(state, value, turn)

    {new_state, new_number}
  end

  defp get_new_number(0, _), do: 0
  defp get_new_number(val, turn), do: turn - val
end
