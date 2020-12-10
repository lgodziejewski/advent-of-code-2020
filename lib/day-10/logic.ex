defmodule Advent.Day10 do
  @day_no "10"

  def run do
    IO.puts("Starting day #{@day_no} logic\n")

    # ReadInput.read_input("lib/day-#{@day_no}/test-input")
    # ReadInput.read_input("lib/day-#{@day_no}/test-input-2")
    input =
      ReadInput.read_input("lib/day-#{@day_no}/input")
      |> Enum.map(&String.to_integer/1)

    sorted_list = Enum.sort(input)

    part1(sorted_list)
    part2(sorted_list)

    IO.puts("\nDay #{@day_no} logic finished")
  end

  defp part1(input) do
    IO.puts("\n Part 1:\n")

    %{1 => ones, 3 => threes} =
      input
      |> Enum.reduce(%{1 => 0, 2 => 0, 3 => 1, prev: 0}, fn el, acc ->
        %{prev: prev} = acc
        diff = el - prev
        new_count = Map.get(acc, diff) + 1

        acc
        |> put_in([:prev], el)
        |> put_in([diff], new_count)
      end)

    IO.inspect(ones * threes, label: "Result")
  end

  defp part2(input) do
    IO.puts("\n Part 2:\n")

    list = [0] ++ input

    {time, _} =
      :timer.tc(fn ->
        part2_reduce(list)
      end)

    IO.inspect(time, label: "reduce time [us]")
  end

  defp part2_reduce(input) do
    {scores, _} =
      input
      |> Enum.reduce({%{}, []}, fn el, acc ->
        {scores, previous_three} = acc

        score =
          previous_three
          |> Enum.map(&{&1, el - &1})
          |> Enum.filter(fn {_, diff} -> diff <= 3 end)
          |> Enum.map(fn {el, _} -> Map.get(scores, el, 0) end)
          |> Enum.reduce(0, &(&1 + &2))
          |> normalize_score()

        new_previous = new_previous(previous_three, el)
        new_scores = put_in(scores, [el], score)

        {new_scores, new_previous}
      end)

    max = Enum.max(input)

    IO.inspect(Map.get(scores, max), label: "Result reduce")
  end

  defp normalize_score(0), do: 1
  defp normalize_score(score), do: score

  defp new_previous([], el), do: [el]

  defp new_previous([_skip, second, third], el) do
    new_previous([second, third], el)
  end

  defp new_previous(previous, el) do
    previous ++ [el]
  end
end
