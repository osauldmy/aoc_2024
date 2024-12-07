defmodule Day03 do
  defp example,
    # do: "xmul(2,4)%&mul[3,7]!@^do_not_mul(5,5)+mul(32,64]then(mul(11,8)mul(8,5))"
    do: "xmul(2,4)&mul[3,7]!^don't()_mul(5,5)+mul(32,64](mul(11,8)undo()?mul(8,5))"

  defp read_input, do: File.read!("inputs/03.txt")

  def first do
    # find mul(x,y) occurrences
    Regex.scan(~r/mul\(\d+,\d+\)/, read_input())
    # unwrap list of lists
    |> Enum.map(&Enum.at(&1, 0))
    # extract x,y from mul(x,y)
    |> Enum.map(&Regex.scan(~r/\d+,\d+/, &1))
    # double unwrap list of lists
    |> Enum.map(&Enum.at(&1, 0))
    |> Enum.map(&Enum.at(&1, 0))
    # parse pairs into integers
    |> Enum.map(&String.split(&1, ","))
    |> Enum.map(fn lst -> lst |> Enum.map(&String.to_integer/1) end)
    # multiply pairs and sum results
    |> Enum.map(fn [x, y] -> x * y end)
    |> Enum.sum()
  end

  def second do
    Regex.scan(~r/mul\(\d+,\d+\)|do\(\)|don't\(\)/, read_input())
    |> Enum.map(&Enum.at(&1, 0))
    |> Enum.reduce([true, 0], fn operation, acc ->
      [mul_enabled, sum] = acc

      {new_mul_enabled, new_sum} =
        case operation do
          "do()" ->
            {true, 0}

          "don't()" ->
            {false, 0}

          _ when not mul_enabled ->
            {mul_enabled, 0}

          _ ->
            [x, y] =
              # extract [["x,y"]] from "mul(x,y)"
              Regex.scan(~r/\d+,\d+/, operation)
              # double unwrap list of lists
              |> hd
              |> hd
              # split string into list and parse integers
              |> String.split(",")
              |> Enum.map(&String.to_integer/1)

            {mul_enabled, x * y}
        end

      [new_mul_enabled, sum + new_sum]
    end)
    |> Enum.at(1)
  end
end
