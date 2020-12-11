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

    {time, _} =
      :timer.tc(fn ->
        part1(map, {size_x, size_y})
      end)

    IO.inspect(time, label: "part 1 time [us]")

    {time, _} =
      :timer.tc(fn ->
        part2(map, {size_x, size_y})
      end)

    IO.inspect(time, label: "part 2 time [us]")

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

    map_with_neighbours = append_neighbours(map, size)

    {result_map, _iterations} = do_round(4, map_with_neighbours, size, :changed, 1)

    calc_result(result_map, size) |> IO.inspect(label: "Result")
  end

  defp append_neighbours(map, size) do
    {size_x, size_y} = size

    range(size_y)
    |> Enum.reduce(%{}, fn y, acc ->
      range(size_x)
      |> Enum.reduce(acc, fn x, map_with_neighbours ->
        coords = {x, y}
        element = Map.get(map, coords)
        neighbour_coords = get_surrounding_coords(coords)

        Map.put(map_with_neighbours, coords, %{value: element, other: neighbour_coords})
      end)
    end)
  end

  defp get_surrounding_coords(coords) do
    {x, y} = coords

    [{x - 1, y - 1}, {x, y - 1}, {x + 1, y - 1}] ++
      [{x - 1, y}, {x + 1, y}] ++
      [{x - 1, y + 1}, {x, y + 1}, {x + 1, y + 1}]
  end

  defp part2(map, size) do
    IO.puts("\n Part 2:\n")

    map_with_neighbours = get_visible_neighbours_coords(map, size)

    {result_map, _iterations} = do_round(5, map_with_neighbours, size, :changed, 1)

    calc_result(result_map, size) |> IO.inspect(label: "Result")
  end

  defp get_visible_neighbours_coords(map, size) do
    {size_x, size_y} = size

    range(size_y)
    |> Enum.reduce(%{}, fn y, acc ->
      range(size_x)
      |> Enum.reduce(acc, fn x, map_with_neighbours ->
        coords = {x, y}
        element = Map.get(map, coords)
        neighbour_coords = get_nearest_coords(map, coords)

        Map.put(map_with_neighbours, coords, %{value: element, other: neighbour_coords})
      end)
    end)
  end

  defp get_nearest_coords(map, coords) do
    directions = [{-1, -1}, {0, -1}, {1, -1}, {-1, 0}, {1, 0}, {-1, 1}, {0, 1}, {1, 1}]

    directions
    |> Enum.map(fn dir ->
      find_element(map, coords, dir)
    end)
    |> Enum.reject(&is_nil(&1))
  end

  defp find_element(map, coords, delta) do
    {x, y} = coords
    {d_x, d_y} = delta
    new_coords = {x + d_x, y + d_y}
    el_value = Map.get(map, new_coords)

    case el_value do
      "." -> find_element(map, new_coords, delta)
      nil -> nil
      _ -> new_coords
    end
  end

  defp do_round(_threshold, map, _, :stale, iteration), do: {map, iteration}

  defp do_round(threshold, map, size, :changed, iteration) do
    {size_x, size_y} = size

    # IO.puts("\n Iteration: #{iteration}:\n")

    res =
      range(size_y)
      |> Enum.reduce({%{}, :stale}, fn y, acc ->
        range(size_x)
        |> Enum.reduce(acc, fn x, {new_map, status} ->
          coords = {x, y}
          %{value: element, other: neighbours} = Map.get(map, coords)

          {next_value, changed} = get_next_value(element, threshold, map, neighbours)
          updated_map = Map.put(new_map, coords, %{value: next_value, other: neighbours})
          updated_status = normalize_changed(status, changed)
          {updated_map, updated_status}
        end)
      end)

    {current_map, status} = res

    # print_map(current_map, size)

    do_round(threshold, current_map, size, status, iteration + 1)
  end

  defp range(size) do
    0..(size - 1)
  end

  defp normalize_changed(_, :changed), do: :changed
  defp normalize_changed(val, :stale), do: val

  # If a seat is empty (L) and there are no occupied seats adjacent to it, the seat becomes occupied.
  # If a seat is occupied (#) and four or more seats adjacent to it are also occupied, the seat becomes empty.
  # Otherwise, the seat's state does not change.
  defp get_next_value(".", _, _, _), do: {".", :stale}

  defp get_next_value("#", threshold, map, neighbour_coords) do
    res =
      neighbour_coords
      |> Enum.map(&get_in(map, [&1, :value]))
      |> Enum.filter(&(&1 == "#"))
      |> Enum.count()

    if res >= threshold do
      {"L", :changed}
    else
      {"#", :stale}
    end
  end

  defp get_next_value("L", _, map, neighbour_coords) do
    res =
      neighbour_coords
      |> Enum.map(&get_in(map, [&1, :value]))
      |> Enum.filter(&(&1 == "#"))
      |> Enum.count()

    if res == 0 do
      {"#", :changed}
    else
      {"L", :stale}
    end
  end

  defp calc_result(result_map, size) do
    {size_x, size_y} = size

    range(size_y)
    |> Enum.reduce(0, fn y, acc ->
      range(size_x)
      |> Enum.reduce(acc, fn x, acc2 ->
        coords = {x, y}
        element = get_in(result_map, [coords, :value])

        if element == "#" do
          acc2 + 1
        else
          acc2
        end
      end)
    end)
  end

  defp print_map(map, {size_x, size_y}) do
    0..(size_y - 1)
    |> Enum.map(fn y ->
      0..(size_x - 1)
      |> Enum.map(fn x -> get_in(map, [{x, y}, :value]) end)
      |> Enum.join("")
    end)
    |> Enum.join("\n")
    |> IO.puts()
  end
end
