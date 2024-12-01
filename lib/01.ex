defmodule Day01 do
  defp example,
    do: """
    3   4
    4   3
    2   5
    1   3
    3   9
    3   3
    """

  defp read_input, do: File.read!("inputs/01.txt")

  defp preprocess_input do
    # example()
    read_input()
    |> String.split("\n", trim: true)
    |> Enum.map(fn line -> String.split(line) |> Enum.map(&String.to_integer/1) end)
    |> Enum.zip()
    |> Enum.map(&Tuple.to_list/1)
  end

  def first do
    preprocess_input()
    |> Enum.map(&Enum.sort/1)
    |> Enum.zip()
    |> Enum.reduce(0, fn {left, right}, acc -> acc + abs(left - right) end)
  end

  def second do
    [left_column, right_column] = preprocess_input()
    freq_map = Enum.frequencies(right_column)
    Enum.reduce(left_column, 0, fn key, acc -> acc + key * Map.get(freq_map, key, 0) end)
  end
end
