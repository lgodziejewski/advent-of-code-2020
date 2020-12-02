IO.puts("Starting day 1 logic\n")

input = ReadInput.read_input("day-1/input") |> Enum.map(& String.to_integer(&1))

IO.puts("\n Part 1:\n")
try do
  Enum.find(input, fn el1 ->
    res_2 = Enum.find(input, fn el2 -> el1 + el2 == 2020 end)

    case res_2 do
      nil -> false
      _ ->
        IO.inspect(el1, label: "First number")
        IO.inspect(res_2, label: "Second number")
        throw(el1 * res_2)
    end
  end)
catch
  result -> IO.inspect(result, label: "Result")
end

IO.puts("\n Part 2:\n")

try do
  Enum.each(input, fn el1 ->
    Enum.each(input, fn el2 ->
      res_3 = Enum.find(input, fn el3 -> el1 + el2 + el3 == 2020 end)

      case res_3 do
        nil -> false
        _ ->
          IO.inspect(el1, label: "First number")
          IO.inspect(el2, label: "Second number")
          IO.inspect(res_3, label: "Third number")
          throw(el1 * el2 * res_3)
      end
    end)
  end)
catch
  result -> IO.inspect(result, label: "Result")
end

IO.puts("\nDay 1 logic finished")
