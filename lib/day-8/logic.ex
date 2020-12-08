defmodule Advent.Day8 do
  @day_no "8"

  def run do
    IO.puts("Starting day #{@day_no} logic\n")

    # input = ReadInput.read_input("lib/day-#{@day_no}/test-input")
    input = ReadInput.read_input("lib/day-#{@day_no}/input")

    instruction_map = parse_input(input)

    part1(instruction_map)
    part2(instruction_map)

    IO.puts("\nDay #{@day_no} logic finished")
  end

  defp part1(input) do
    IO.puts("\n Part 1:\n")

    invoke_instruction(input, 0, 0) |> IO.inspect(label: "Result")
  end

  defp part2(input) do
    IO.puts("\n Part 2:\n")
  end

  def parse_input(input) do
    input
    |> Enum.with_index()
    |> Enum.map(fn {instruction, index} ->
      [instr, str_value] = String.split(instruction, " ")

      value = String.to_integer(str_value)

      {index, %{instruction: instr, value: value, count: 0}}
    end)
    |> Map.new()
  end

  defp invoke_instruction(instruction_map, position, result) do
    %{instruction: instr, value: value, count: count} = Map.get(instruction_map, position)

    if count > 0 do
      result
    else
      instruction_map = put_in(instruction_map, [position, :count], count + 1)

      {new_position, new_result} =
        case instr do
          "acc" -> {position + 1, result + value}
          "nop" -> {position + 1, result}
          "jmp" -> {position + value, result}
        end

      invoke_instruction(instruction_map, new_position, new_result)
    end
  end
end
