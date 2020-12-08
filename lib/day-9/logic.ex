defmodule Advent.Day9 do
  @day_no "9"

  def run do
    IO.puts("Starting day #{@day_no} logic\n")

    # ReadInput.read_input("lib/day-#{@day_no}/test-input")
    input =
      ReadInput.read_input("lib/day-#{@day_no}/input")
      |> Enum.map(&String.to_integer/1)

    first_result = part1(input)
    part2(input, first_result)

    IO.puts("\nDay #{@day_no} logic finished")
  end

  defp part1(input) do
    IO.puts("\n Part 1:\n")

    preamble_size = 25

    {result, _} = find_first_incorrect(input, preamble_size, preamble_size)

    IO.inspect(result, label: "Result")
  end

  defp part2(input, first_result) do
    IO.puts("\n Part 2:\n")

    wrapped_range =
      input
      |> Enum.with_index()
      |> Enum.find_value(nil, fn {el, idx} ->
        shorter_input = Enum.drop(input, idx)
        check_sum(shorter_input, idx, [el], first_result)
      end)

    {true, range} = wrapped_range

    min = Enum.min(range)
    max = Enum.max(range)

    IO.inspect(min + max, label: "Result")
  end

  defp check_sum(input, current_position, elements, target) do
    sum = Enum.reduce(elements, 0, fn el, acc -> acc + el end)
    size = Enum.count(elements)

    case compare_ints(sum, target) do
      :higher ->
        false

      :equal ->
        {true, elements}

      :lower ->
        new_elements = Enum.take(input, size + 1)
        check_sum(input, current_position, new_elements, target)
    end
  end

  defp compare_ints(a, b) do
    cond do
      a > b -> :higher
      a == b -> :equal
      a < b -> :lower
    end
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
