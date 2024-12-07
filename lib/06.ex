defmodule Day06 do
  defp example,
    do: """
    ....#.....
    .........#
    ..........
    ..#.......
    .......#..
    ..........
    .#..^.....
    ........#.
    #.........
    ......#...
    """

  defp read_input, do: File.read!("inputs/06.txt")

  defp preprocess_input do
    lines =
      # example()
      read_input()
      |> String.split("\n", trim: true)

    maze_map =
      for {line, y} <- Enum.with_index(lines) do
        for {value, x} <- Enum.with_index(String.split(line, "", trim: true)) do
          %{{y, x} => value}
        end
      end
      |> List.flatten()
      |> Enum.reduce(&Map.merge/2)

    {maze_map, length(lines), String.length(hd(lines))}
  end

  def first do
    {maze_map, height, width} = preprocess_input()

    unique_moves =
      simulate_guard_moves(
        maze_map,
        height,
        width,
        MapSet.new([find_guard(maze_map)])
      )

    MapSet.size(unique_moves)
  end

  def second do
  end

  defp find_guard(maze_map) do
    Enum.find(maze_map, fn {_, value} -> value in ["^", ">", "<", "v"] end) |> elem(0)
  end

  defp simulate_guard_moves(maze_map, height, width, already_visited) do
    {new_map, {next_y, next_x}} = get_next_guard_move(maze_map)

    if move_still_within_bounds?(next_y, height, next_x, width) do
      simulate_guard_moves(
        new_map,
        height,
        width,
        MapSet.put(already_visited, {next_y, next_x})
      )
    else
      already_visited
    end
  end

  defp move_still_within_bounds?(y, height, x, width),
    do: x < width and x >= 0 and y < height and y >= 0

  defp get_next_guard_move(maze_map) do
    position = find_guard(maze_map)
    {y, x} = position
    direction = maze_map[{y, x}]

    maybe_new_position = get_next_position(direction, y, x)
    new_position = if maze_map[maybe_new_position] != "#", do: maybe_new_position, else: position

    new_direction =
      if maze_map[maybe_new_position] == "#", do: rotate_guard(direction), else: direction

    new_map =
      Map.merge(maze_map, %{
        position => "X",
        new_position => new_direction
      })

    {new_map, position}
  end

  def get_next_position(direction, y, x) do
      case direction do
        "^" -> {y - 1, x}
        "v" -> {y + 1, x}
        "<" -> {y, x - 1}
        ">" -> {y, x + 1}
      end
    end

  defp rotate_guard(direction) do
    case direction do
      "<" -> "^"
      "^" -> ">"
      ">" -> "v"
      "v" -> "<"
    end
  end

  defp draw_map(map, height, width) do
    lines =
      for y <- 0..height do
        line =
          for x <- 0..width do
            map[{y, x}]
          end

        Enum.join(line, "")
      end

    drawn_map = Enum.join(lines, "\n")
    IO.puts(drawn_map)
  end
end
