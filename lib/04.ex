defmodule Day04 do
  defp example,
    do: """
    MMMSXXMASM
    MSAMXMSMSA
    AMXSXMAAMM
    MSAMASMSMX
    XMASAMXAMM
    XXAMMXXAMA
    SMSMSASXSS
    SAXAMASAAA
    MAMMMXMMMM
    MXMXAXMASX
    """

  defp read_input, do: File.read!("inputs/04.txt")

  defp preprocess_input do
    lines =
      # example()
      read_input()
      |> String.split("\n", trim: true)

    x_len = String.length(hd(lines))
    y_len = lines |> length()

    {lines, x_len, y_len}
  end

  def first do
    {lines, x_len, y_len} = preprocess_input()

    for y <- 0..(y_len - 1) do
      for x <- 0..(x_len - 1) do
        if lines |> at(y, x) == "X", do: check_all_directions(lines, y, y_len, x, x_len)
      end
    end
    |> List.flatten()
    # filter true's from list and count them
    |> Enum.count(& &1)
  end

  defp check_all_directions(lines, y, y_len, x, x_len) do
    for direction <- [:north, :south, :west, :east, :nw, :ne, :sw, :se] do
      check_direction(lines, y, y_len, x, x_len, direction)
    end
  end

  defp check_direction(_, y, _, _, _, :north) when y - 3 < 0, do: false
  defp check_direction(_, y, y_len, _, _, :south) when y + 3 >= y_len, do: false
  defp check_direction(_, _, _, x, _, :west) when x - 3 < 0, do: false
  defp check_direction(_, _, _, x, x_len, :east) when x + 3 >= x_len, do: false
  defp check_direction(_, y, _, x, _, :nw) when y - 3 < 0 or x - 3 < 0, do: false
  defp check_direction(_, y, _, x, x_len, :ne) when y - 3 < 0 or x + 3 >= x_len, do: false
  defp check_direction(_, y, y_len, x, _, :sw) when y + 3 >= y_len or x - 3 < 0, do: false

  defp check_direction(_, y, y_len, x, x_len, :se) when y + 3 >= y_len or x + 3 >= x_len,
    do: false

  defp check_direction(lines, y, _, x, _, :north) do
    Enum.slice(lines, y - 3, 4) |> Enum.map_join(&String.at(&1, x)) == "SAMX"
  end

  defp check_direction(lines, y, _, x, _, :south) do
    Enum.slice(lines, y, 4) |> Enum.map_join(&String.at(&1, x)) == "XMAS"
  end

  defp check_direction(lines, y, _, x, _, :west) do
    Enum.at(lines, y) |> String.slice(x - 3, 4) == "SAMX"
  end

  defp check_direction(lines, y, _, x, _, :east) do
    Enum.at(lines, y) |> String.slice(x, 4) == "XMAS"
  end

  defp check_direction(lines, y, _, x, _, diagonal) do
    case diagonal do
      :nw -> for(i <- 0..3, do: lines |> at(y - i, x - i))
      :ne -> for(i <- 0..3, do: lines |> at(y - i, x + i))
      :sw -> for(i <- 0..3, do: lines |> at(y + i, x - i))
      :se -> for(i <- 0..3, do: lines |> at(y + i, x + i))
    end
    |> Enum.join() == "XMAS"
  end

  def second do
    {lines, x_len, y_len} = preprocess_input()

    for y <- 0..(y_len - 1) do
      for x <- 0..(x_len - 1) do
        check_x_mas(lines, y, y_len, x, x_len)
      end
    end
    |> List.flatten()
    # filter true's from list and count them
    |> Enum.count(& &1)
  end

  def at(lines, y, x) when is_list(lines) and y < length(lines),
    do: String.at(Enum.at(lines, y), x)

  defp check_x_mas(_, y, y_len, x, x_len) when y + 2 >= y_len or x + 2 >= x_len, do: false

  defp check_x_mas(lines, y, _, x, _) do
    cond do
      lines |> at(y + 1, x + 1) != "A" -> false
      (lines |> at(y, x)) not in ["M", "S"] -> false
      (lines |> at(y + 2, x)) not in ["M", "S"] -> false
      (lines |> at(y, x + 2)) not in ["M", "S"] -> false
      (lines |> at(y + 2, x + 2)) not in ["M", "S"] -> false
      lines |> at(y, x) == lines |> at(y + 2, x + 2) -> false
      lines |> at(y + 2, x) == lines |> at(y, x + 2) -> false
      true -> true
    end
  end
end
