defmodule Advent.Day4 do
  @day_no "4"

  def run do
    IO.puts("Starting day #{@day_no} logic\n")

    input = ReadInput.read_input("lib/day-#{@day_no}/input")

    # input = ReadInput.read_input("lib/day-#{@day_no}/test-input2")

    passport_map = parse_input(input)

    part1(passport_map)
    part2(passport_map)

    IO.puts("\nDay #{@day_no} logic finished")
  end

  defp part1(input) do
    IO.puts("\n Part 1:\n")

    result =
      Enum.reduce(input, 0, fn el, acc ->
        if is_valid(el) do
          acc + 1
        else
          acc
        end
      end)

    IO.inspect(result, label: "Valid passports")
  end

  defp part2(input) do
    IO.puts("\n Part 2:\n")

    result =
      Enum.reduce(input, 0, fn el, acc ->
        if is_valid(el) and is_valid_values(el) do
          acc + 1
        else
          acc
        end
      end)

    IO.inspect(result, label: "Valid passports")
  end

  defp parse_input(input) do
    input
    |> Enum.chunk_by(fn el -> el == "" end)
    |> Enum.map(&Enum.join(&1, " "))
    |> Enum.filter(&(&1 !== ""))
    |> Enum.map(&parse_row/1)
  end

  defp parse_row(row) do
    row
    |> String.split(" ")
    |> Enum.map(&String.split(&1, ":"))
    |> Map.new(fn [key, val] -> {key, val} end)
  end

  defp is_valid(entry) do
    Enum.all?(required_fields(), &Map.has_key?(entry, &1))
  end

  defp is_valid_values(entry) do
    Enum.all?(required_fields(), fn field ->
      value = Map.get(entry, field)

      validate_field(field, value)
    end)
  end

  # byr (Birth Year) - four digits; at least 1920 and at most 2002.
  # iyr (Issue Year) - four digits; at least 2010 and at most 2020.
  # eyr (Expiration Year) - four digits; at least 2020 and at most 2030.
  # hgt (Height) - a number followed by either cm or in:
  # If cm, the number must be at least 150 and at most 193.
  # If in, the number must be at least 59 and at most 76.
  # hcl (Hair Color) - a # followed by exactly six characters 0-9 or a-f.
  # ecl (Eye Color) - exactly one of: amb blu brn gry grn hzl oth.
  # pid (Passport ID) - a nine-digit number, including leading zeroes.

  defp validate_field("byr", val) do
    value = String.to_integer(val)
    value >= 1920 and value <= 2002
  end

  defp validate_field("iyr", val) do
    value = String.to_integer(val)
    value >= 2010 and value <= 2020
  end

  defp validate_field("eyr", val) do
    value = String.to_integer(val)
    value >= 2020 and value <= 2030
  end

  defp validate_field("hgt", value) do
    {number_str, unit} = String.split_at(value, -2)
    number = String.to_integer(number_str)

    case unit do
      "cm" -> number >= 150 and number <= 193
      "in" -> number >= 59 and number <= 76
      _ -> false
    end
  end

  defp validate_field("hcl", value) do
    re = ~r/^#[a-f0-9]{6}$/

    String.match?(value, re)
  end

  defp validate_field("ecl", value) do
    Enum.any?(["amb", "blu", "brn", "gry", "grn", "hzl", "oth"], fn el -> el == value end)
  end

  defp validate_field("pid", value) do
    String.length(value) == 9
  end

  defp required_fields do
    ["byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid"]
  end

  # defp optional_fields do
  #   ["cid"]
  # end
end
