defmodule Advent.Day9 do
  @day_no "9"

  def run do
    IO.puts("Starting day #{@day_no} logic\n")

    # ReadInput.read_input("lib/day-#{@day_no}/test-input")
    input =
      ReadInput.read_input("lib/day-#{@day_no}/input")
      |> Enum.map(&String.to_integer/1)

    part1(input)

    IO.puts("\nDay #{@day_no} logic finished")
  end

  defp part1(input) do
    IO.puts("\n Part 1:\n")

    preamble_size = 25

      find_first_incorrect(input, preamble_size, preamble_size) |> IO.inspect(label: "Result")
  end

  defp find_first_incorrect(list, preamble_size, position) do
    [current_element | preamble_reversed] =
      list
      |> Enum.slice(position - preamble_size, preamble_size + 1)
      |> Enum.reverse()

    preamble = Enum.reverse(preamble_reversed)

    partial_map = preamble |> Enum.map(&{current_element - &1, &1}) |> Map.new()

    case find_pair(partial_map, preamble) do
      true -> find_first_incorrect(list, preamble_size, position + 1)
      false -> {current_element, position}
    end
  end

  defp find_pair(elements_map, elements) do
    elements
    |> Enum.any?(fn el ->
      other_el = Map.get(elements_map, el)

      if is_nil(other_el) or el == other_el do
        false
      else
        true
      end
    end)
  end
end
