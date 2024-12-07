defmodule Day07 do
  defp example,
    do: """
    190: 10 19
    3267: 81 40 27
    83: 17 5
    156: 15 6
    7290: 6 8 6 15
    161011: 16 10 13
    192: 17 8 14
    21037: 9 7 18 13
    292: 11 6 16 20
    """

  defp read_input, do: File.read!("inputs/07.txt")

  defp preprocess_input do
    # example()
    read_input()
    |> String.split("\n", trim: true)
    |> Enum.map(&String.split(&1, ": "))
    |> Enum.map(fn [expected, x] ->
      {String.to_integer(expected), String.split(x) |> Enum.map(&String.to_integer/1)}
    end)
  end

  def first do
    preprocess_input()
    |> Enum.filter(fn {expected, numbers} ->
      expected in List.flatten(check(numbers))
    end)
    |> Enum.map(&elem(&1, 0))
    |> Enum.sum()
  end

  def second do
    preprocess_input()
    |> Enum.filter(fn {expected, numbers} ->
      expected in List.flatten(check(numbers, 0, true))
    end)
    |> Enum.map(&elem(&1, 0))
    |> Enum.sum()
  end

  defp check(numbers, acc \\ 0, with_concat \\ false) do
    if Enum.empty?(numbers) do
      acc
    else
      [head | tail] = numbers
      add_and_mul = [check(tail, acc + head, with_concat), check(tail, acc * head, with_concat)]

      if with_concat,
        do: [check(tail, concat(acc, head), with_concat) | add_and_mul],
        else: add_and_mul
    end
  end

  defp concat(a, b),
    do: String.to_integer(Enum.join([Integer.to_string(a), Integer.to_string(b)]))
end
