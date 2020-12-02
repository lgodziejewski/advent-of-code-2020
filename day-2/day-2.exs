IO.puts("Starting day 2 logic\n")

input = ReadInput.read_input("day-2/input")

IO.inspect(input)

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


IO.puts("\nDay 2 logic finished")
