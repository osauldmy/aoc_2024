defmodule Day02 do
  defp example,
    do: """
    7 6 4 2 1
    1 2 7 8 9
    9 7 6 2 1
    1 3 2 4 5
    8 6 4 4 1
    1 3 6 7 9
    """

  defp read_input, do: File.read!("inputs/02.txt")

  @increasing MapSet.new([1, 2, 3])
  @decreasing MapSet.new([-1, -2, -3])

  defp preprocess_input do
    # example()
    read_input()
    |> String.split("\n", trim: true)
    |> Enum.map(fn line -> String.split(line) |> Enum.map(&String.to_integer/1) end)
  end

  def first do
    # For each line:
    #   Make pairs -> calculate pair diffs -> convert to sets -> compare with allowed sets
    subsets =
      preprocess_input()
      |> Enum.map(fn line ->
        Enum.chunk_every(line, 2, 1, :discard)
        |> Enum.map(fn [a, b] -> a - b end)
        |> MapSet.new()
      end)
      |> Enum.map(fn set ->
        MapSet.subset?(set, @increasing) || MapSet.subset?(set, @decreasing)
      end)

    Map.get(Enum.frequencies(subsets), true)
  end

  def second do
    preprocess_input() |> Enum.filter(&report_safe?/1) |> length()
  end

  defp report_safe?(line) do
    0..(length(line) + 1)
    # try to delete a single level at each position
    # including length(line) + 1 position which is whole list,
    # then compute if it's safe
    |> Enum.map(&report_without_level_safe?(List.delete_at(line, &1)))
    |> Enum.any?()
  end

  defp report_without_level_safe?(line) do
    diff_freq_map =
      line
      |> Enum.chunk_every(2, 1, :discard)
      |> Enum.map(fn [a, b] -> a - b end)
      |> Enum.frequencies()

    {is_increasing, is_decreasing} =
      Enum.reduce(diff_freq_map, {0, 0}, fn {key, value}, acc ->
        {inc, dec} = acc

        inc = if key > 0, do: inc + value, else: inc
        dec = if key < 0, do: dec + value, else: dec

        {inc, dec}
      end)

    filtering_set = if is_increasing > is_decreasing, do: @increasing, else: @decreasing
    for({key, _} <- diff_freq_map, do: key in filtering_set) |> Enum.all?()
  end
end
