defmodule Advent.Day5 do
  @day_no "5"

  def run do
    IO.puts("Starting day #{@day_no} logic\n")

    input = ReadInput.read_input("lib/day-#{@day_no}/input")

    # input = ReadInput.read_input("lib/day-#{@day_no}/test-input")

    boarding_passes = parse_input(input)

    part1(boarding_passes)
    part2(boarding_passes)

    IO.puts("\nDay #{@day_no} logic finished")
  end

  defp part1(input) do
    IO.puts("\n Part 1:\n")

    result = Enum.max_by(input, fn {_, _, seat_id} -> seat_id end)

    IO.inspect(result)
  end

  defp part2(input) do
    IO.puts("\n Part 2:\n")

    seat_ids = input |> Enum.map(fn {_, _, seat_id} -> seat_id end) |> Enum.sort()

    seat_ids
    |> binary_search(true)
    |> IO.inspect(label: "Result")
  end

  defp binary_search(list = [val], true) when length(list) == 1, do: val - 1
  defp binary_search(list = [val], false) when length(list) == 1, do: val + 1

  defp binary_search(list, _) do
    seats_count = length(list)
    [offset | _] = list

    middle = div(seats_count, 2)

    value = Enum.at(list, middle)
    offset_value = value - offset

    is_further? = offset_value == middle

    {list_start, list_end} = Enum.split(list, middle)

    new_list =
      case is_further? do
        true -> list_end
        false -> list_start
      end

    binary_search(new_list, is_further?)
  end

  # possible values: FB, LR
  # B -> 1
  # F -> 0
  # R -> 1
  # L -> 0
  defp parse_input(input) do
    input
    |> Enum.map(fn entry ->
      {row, col} = String.split_at(entry, -3)

      row_no =
        row
        |> String.replace("F", "0")
        |> String.replace("B", "1")
        |> String.to_integer(2)

      col_no =
        col
        |> String.replace("R", "1")
        |> String.replace("L", "0")
        |> String.to_integer(2)

      seat_id = row_no * 8 + col_no

      {row_no, col_no, seat_id}
    end)
  end
end
