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

    seat_ids = Enum.map(input, fn {_, _, seat_id} -> seat_id end)
    el_count = Enum.count(seat_ids)

    {min, max, sum} =
      Enum.reduce(seat_ids, {1_000_000, 0, 0}, fn el, acc ->
        {orig_min, orig_max, orig_sum} = acc

        new_sum = orig_sum + el

        new_min =
          case el < orig_min do
            true -> el
            false -> orig_min
          end

        new_max =
          case el > orig_max do
            true -> el
            false -> orig_max
          end

        {new_min, new_max, new_sum}
      end)
      |> IO.inspect()

    expected_sum = (min + max) / 2 * (el_count + 1)
    lacking_element = expected_sum - sum

    IO.inspect(lacking_element, label: "Result")
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
