defmodule Advent.Day13 do
  @day_no "13"

  def run do
    IO.puts("Starting day #{@day_no} logic\n")

    # input = ReadInput.read_input("lib/day-#{@day_no}/test-input")

    input = ReadInput.read_input("lib/day-#{@day_no}/input")

    part1(input)
    part2(input)

    IO.puts("\nDay #{@day_no} logic finished")
  end

  defp parse_input_part1(input) do
    [timestamp_str, data_str] = input

    timestamp = String.to_integer(timestamp_str)

    data =
      data_str
      |> String.split(",")
      |> Enum.map(fn el ->
        if el == "x" do
          nil
        else
          String.to_integer(el)
        end
      end)
      |> Enum.reject(&is_nil(&1))

    {timestamp, data}
  end

  defp part1(input) do
    IO.puts("\n Part 1:\n")

    {orig_timestamp, data} = parse_input_part1(input)

    {target_timestamp, bus_id} = check_values(orig_timestamp, data)

    ((target_timestamp - orig_timestamp) * bus_id)
    |> IO.inspect(label: "Result")
  end

  defp check_values(timestamp, data) do
    el =
      Enum.find(data, fn bus_id ->
        rem(timestamp, bus_id) == 0
      end)

    if is_nil(el) do
      check_values(timestamp + 1, data)
    else
      {timestamp, el}
    end
  end

  defp part2(input) do
    IO.puts("\n Part 2:\n")

    parsed_data = parse_input_part2(input)

    [{value, remainder} | rest] = parsed_data

    find_common_el(value, remainder, rest)
    |> IO.inspect(label: "Result")
  end

  defp parse_input_part2(input) do
    [_, data_str] = input

    data =
      data_str
      |> String.split(",")
      |> Enum.with_index()
      |> Enum.map(fn {bus_id_str, offset} ->
        bus_id =
          if bus_id_str == "x" do
            nil
          else
            String.to_integer(bus_id_str)
          end

        {bus_id, offset}
      end)
      |> Enum.reject(fn {el, _} -> is_nil(el) end)
      |> Enum.map(fn {bus_id, offset} ->
        if offset == 0 do
          {bus_id, offset}
        else
          remainder = bus_id - Integer.mod(offset, bus_id)
          {bus_id, remainder}
        end
      end)
      |> Enum.sort_by(fn {bus_id, _} -> bus_id end)
      |> Enum.reverse()

    data
  end

  defp find_common_el(_, start_value, []), do: start_value

  defp find_common_el(increment, start_value, list) do
    [{divisor, remainder} | rest] = list

    result = check_remainder(increment, start_value, divisor, remainder)

    find_common_el(increment * divisor, result, rest)
  end

  defp check_remainder(increment, base, divisor, expected_remainder) do
    remainder = Integer.mod(base, divisor)

    if remainder == expected_remainder do
      base
    else
      check_remainder(increment, base + increment, divisor, expected_remainder)
    end
  end
end
