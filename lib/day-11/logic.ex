defmodule Advent.Day11 do
  @day_no "11"

  def run do
    IO.puts("Starting day #{@day_no} logic\n")

    # input = ReadInput.read_input("lib/day-#{@day_no}/test-input")
    input = ReadInput.read_input("lib/day-#{@day_no}/input")

    map = parse_input(input)
    size_x = String.length(Enum.at(input, 0))
    size_y = Enum.count(input)

    IO.inspect({size_x, size_y}, label: "size")

    # print_map(map, {size_x, size_y})

    part1(map, {size_x, size_y})
    part2(map)

    IO.puts("\nDay #{@day_no} logic finished")
  end

  defp parse_input(input) do
    input
    |> Enum.with_index()
    |> Enum.reduce(%{}, fn {row, y}, acc ->
      row
      |> String.split("", trim: true)
      |> Enum.with_index()
      |> Enum.reduce(acc, fn {el, x}, acc2 ->
        Map.put(acc2, {x, y}, el)
      end)
    end)
  end

  defp part1(map, size) do
    IO.puts("\n Part 1:\n")

    {result_map, _iterations} = do_round(map, size, :changed, 1)

    {size_x, size_y} = size

    range(size_y)
    |> Enum.reduce(0, fn y, acc ->
      range(size_x)
      |> Enum.reduce(acc, fn x, acc2 ->
        coords = {x, y}
        element = Map.get(result_map, coords)

        if element == "#" do
          acc2 + 1
        else
          acc2
        end
      end)
    end)
    |> IO.inspect(label: "Result")
  end

  defp part2(input) do
    IO.puts("\n Part 2:\n")
  end

  defp do_round(map, _, :stale, iteration), do: {map, iteration}

  defp do_round(map, size, :changed, iteration) do
    {size_x, size_y} = size

    res =
      range(size_y)
      |> Enum.reduce({%{}, :stale}, fn y, acc ->
        range(size_x)
        |> Enum.reduce(acc, fn x, {new_map, status} ->
          coords = {x, y}
          element = Map.get(map, coords)
          {next_value, changed} = get_next_value(element, map, coords)
          updated_map = Map.put(new_map, coords, next_value)
          updated_status = normalize_changed(status, changed)
          {updated_map, updated_status}
        end)
      end)

    {current_map, status} = res

    do_round(current_map, size, status, iteration + 1)
  end

  defp range(size) do
    0..(size - 1)
  end

  defp normalize_changed(_, :changed), do: :changed
  defp normalize_changed(val, :stale), do: val

  # If a seat is empty (L) and there are no occupied seats adjacent to it, the seat becomes occupied.
  # If a seat is occupied (#) and four or more seats adjacent to it are also occupied, the seat becomes empty.
  # Otherwise, the seat's state does not change.
  defp get_next_value(".", _, _), do: {".", :stale}

  defp get_next_value("#", map, coords) do
    res =
      get_surrounding_coords(coords)
      |> Enum.map(&Map.get(map, &1))
      |> Enum.filter(&(&1 == "#"))
      |> Enum.count()

    if res >= 4 do
      {"L", :changed}
    else
      {"#", :stale}
    end
  end

  defp get_next_value("L", map, coords) do
    res =
      get_surrounding_coords(coords)
      |> Enum.map(&Map.get(map, &1))
      |> Enum.filter(&(&1 == "#"))
      |> Enum.count()

    if res == 0 do
      {"#", :changed}
    else
      {"L", :stale}
    end
  end

  defp get_surrounding_coords(coords) do
    {x, y} = coords

    [{x - 1, y - 1}, {x, y - 1}, {x + 1, y - 1}] ++
      [{x - 1, y}, {x + 1, y}] ++
      [{x - 1, y + 1}, {x, y + 1}, {x + 1, y + 1}]
  end

  defp print_map(map, {size_x, size_y}) do
    0..(size_y - 1)
    |> Enum.map(fn y ->
      0..(size_x - 1)
      |> Enum.map(fn x -> Map.get(map, {x, y}) end)
      |> Enum.join("")
    end)
    |> Enum.join("\n")
    |> IO.puts()
  end
end
