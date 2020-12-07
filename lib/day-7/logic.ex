defmodule Advent.Day7 do
  @day_no "7"

  def run do
    IO.puts("Starting day #{@day_no} logic\n")

    # input = ReadInput.read_input("lib/day-#{@day_no}/test-input")
    input = ReadInput.read_input("lib/day-#{@day_no}/input")

    deps_list = parse_input(input)

    part1(deps_list)
    part2(deps_list)

    IO.puts("\nDay #{@day_no} logic finished")
  end

  defp part1(input) do
    IO.puts("\n Part 1:\n")

    bag_color = "shiny gold"

    bags_tree = %{bag_color => list_to_tree(input, bag_color)}

    bags_tree
    |> get_parents(bag_color)
    |> MapSet.new()
    |> MapSet.size()
    |> IO.inspect(label: "Result")
  end

  defp part2(input) do
    IO.puts("\n Part 2:\n")

    bag_color = "shiny gold"

    input_map = Map.new(input)

    input_map
    |> get_child_count(bag_color)
    |> IO.inspect(label: "Result")
  end

  defp parse_input(input) do
    input
    |> Enum.map(fn el ->
      [parent, children] = String.split(el, "contain ")
      parent_color = get_color(parent)

      parsed_children =
        children
        |> String.split(", ")
        |> parse_children()

      {parent_color, parsed_children}
    end)
  end

  defp get_color(text) do
    String.slice(text, 0, String.length(text) - 6)
  end

  defp parse_children(["no other bags."]), do: []

  defp parse_children(arr) do
    Enum.map(arr, fn el ->
      [count, color_part_1, color_part_2 | _rest] = String.split(el, " ")
      color = color_part_1 <> " " <> color_part_2
      {color, count}
    end)
  end

  defp list_to_tree(list, element_name) do
    parent_nodes =
      Enum.filter(list, fn el ->
        {_name, children} = el

        Enum.any?(children, fn child ->
          {child_name, _count} = child

          child_name == element_name
        end)
      end)

    Enum.reduce(parent_nodes, %{}, fn {name, _}, acc ->
      deps = list_to_tree(list, name)
      Map.put(acc, name, deps)
    end)
  end

  defp get_parents(map, el) do
    parents = Map.get(map, el, [])

    parent_colors = Map.keys(parents)

    parent_colors ++ Enum.flat_map(parent_colors, &get_parents(parents, &1))
  end

  defp get_child_count(map, el) do
    # eg: [{"bright white", "1"}, {"muted yellow", "2"}]
    children = Map.get(map, el)

    Enum.reduce(children, 0, fn child, acc ->
      {child_name, child_count_str} = child
      child_count = String.to_integer(child_count_str)

      child_deps_count = get_child_count(map, child_name)

      acc + child_count * child_deps_count + child_count
    end)
  end
end
