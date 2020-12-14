defmodule Advent.Day14 do
  @day_no "14"

  use Bitwise

  def run do
    IO.puts("Starting day #{@day_no} logic\n")

    # ReadInput.read_input("lib/day-#{@day_no}/test-input")
    input =
      ReadInput.read_input("lib/day-#{@day_no}/input")
      |> parse_input()

    part1(input)
    part2(input)

    IO.puts("\nDay #{@day_no} logic finished")
  end

  defp parse_input(input) do
    input
    |> Enum.map(fn entry ->
      [cmd, value_str] = String.split(entry, " = ")

      if cmd == "mask" do
        {cmd, value_str}
      else
        [_, memory_address] = Regex.run(~r/mem\[(\d+)\]/, cmd)
        value = String.to_integer(value_str)
        {memory_address, value}
      end
    end)
  end

  defp part1(input) do
    IO.puts("\n Part 1:\n")

    initial_state = {%{}, ""}

    Enum.reduce(input, initial_state, fn {cmd, val}, {state, mask} ->
      apply_command(cmd, val, state, mask)
    end)
    |> calc_result()
    |> IO.inspect(label: "Result")
  end

  defp apply_command("mask", val, state, _) do
    and_mask =
      String.replace(val, "X", "1")
      |> String.to_integer(2)

    or_mask =
      String.replace(val, "X", "0")
      |> String.to_integer(2)

    masks = {and_mask, or_mask}
    {state, masks}
  end

  defp apply_command(address, val, state, masks) do
    {and_mask, or_mask} = masks

    value_after_mask =
      val
      |> band(and_mask)
      |> bor(or_mask)

    new_state = Map.put(state, address, value_after_mask)
    {new_state, masks}
  end

  defp calc_result({state, _}) do
    state
    |> Map.values()
    |> Enum.reduce(0, fn el, acc -> acc + el end)
  end

  defp part2(input) do
    IO.puts("\n Part 2:\n")
  end
end
