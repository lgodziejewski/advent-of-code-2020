defmodule Advent.Day14 do
  @day_no "14"

  use Bitwise

  def run do
    IO.puts("Starting day #{@day_no} logic\n")

    # ReadInput.read_input("lib/day-#{@day_no}/test-input-2")
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
        [_, memory_address_str] = Regex.run(~r/mem\[(\d+)\]/, cmd)
        value = String.to_integer(value_str)
        memory_address = String.to_integer(memory_address_str)
        {memory_address, value}
      end
    end)
  end

  defp part1(input) do
    IO.puts("\n Part 1:\n")

    initial_state = {%{}, ""}

    Enum.reduce(input, initial_state, fn {cmd, val}, {state, mask} ->
      apply_command_part1(cmd, val, state, mask)
    end)
    |> calc_result()
    |> IO.inspect(label: "Result")
  end

  defp apply_command_part1("mask", val, state, _) do
    and_mask = String.replace(val, "X", "1") |> String.to_integer(2)
    or_mask = String.replace(val, "X", "0") |> String.to_integer(2)

    masks = {and_mask, or_mask}
    {state, masks}
  end

  defp apply_command_part1(address, val, state, masks) do
    {and_mask, or_mask} = masks

    value_after_mask = val |> band(and_mask) |> bor(or_mask)

    new_state = Map.put(state, address, value_after_mask)
    {new_state, masks}
  end

  defp part2(input) do
    IO.puts("\n Part 2:\n")

    initial_state = {%{}, ""}

    Enum.reduce(input, initial_state, fn {cmd, val}, {state, mask} ->
      apply_command_part2(cmd, val, state, mask)
    end)
    |> calc_result()
    |> IO.inspect(label: "Result")
  end

  defp apply_command_part2("mask", val, state, _), do: {state, val}

  defp apply_command_part2(address, val, state, mask) do
    new_state =
      mask
      |> apply_mask(address)
      |> Enum.reduce(state, fn adr, current_state ->
        Map.put(current_state, adr, val)
      end)

    {new_state, mask}
  end

  defp apply_mask(mask, address) do
    and_mask =
      mask |> String.replace("0", "1") |> String.replace("X", "0") |> String.to_integer(2)

    or_masks = get_mask_variants(mask)
    mid_address = band(address, and_mask)

    or_masks
    |> Enum.map(fn or_mask -> bor(mid_address, or_mask) end)
  end

  defp get_mask_variants(mask) do
    if String.contains?(mask, "X") do
      mask1 = String.replace(mask, "X", "1", global: false)
      mask2 = String.replace(mask, "X", "0", global: false)
      get_mask_variants(mask1) ++ get_mask_variants(mask2)
    else
      [String.to_integer(mask, 2)]
    end
  end

  defp calc_result({state, _}) do
    state
    |> Map.values()
    |> Enum.reduce(0, fn el, acc -> acc + el end)
  end
end
