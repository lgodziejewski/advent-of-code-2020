IO.puts("Starting day 2 logic\n")

input = ReadInput.read_input("day-2/input")

IO.puts("\n Part 1:\n")
res = Enum.reduce([0] ++ input, fn el, acc ->

  [policy, password] = String.split(el, ": ")
  [range, letter] = String.split(policy, " ")
  [min, max] = String.split(range, "-") |> Enum.map(& String.to_integer(&1))

  password_cut = String.replace(password, letter, "")
  letter_count = String.length(password) - String.length(password_cut)

  if (letter_count >= min and letter_count <= max) do
    acc + 1
  else
    acc
  end
end)

IO.inspect(res)


IO.puts("\n Part 2:\n")
res2 = Enum.reduce([0] ++ input, fn el, acc ->

  [policy, password] = String.split(el, ": ")
  [range, letter] = String.split(policy, " ")
  [first_pos, second_pos] = String.split(range, "-") |> Enum.map(& String.to_integer(&1))

  first_match = if (String.at(password, first_pos - 1) == letter), do: 1, else: 0
  second_match = if (String.at(password, second_pos - 1) == letter), do: 1, else: 0

  if (first_match + second_match == 1) do
    acc + 1
  else
    acc
  end
end)

IO.inspect(res2)


IO.puts("\nDay 2 logic finished")
