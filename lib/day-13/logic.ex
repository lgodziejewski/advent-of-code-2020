defmodule Advent.Day13 do
  @day_no "13"

  def run do
    IO.puts("Starting day #{@day_no} logic\n")

    # ReadInput.read_input("lib/day-#{@day_no}/test-input")
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
  end
end
