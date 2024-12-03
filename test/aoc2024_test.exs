defmodule Aoc2024Test do
  use ExUnit.Case

  test "day1" do
    assert Day01.first() == 2_378_066
    assert Day01.second() == 18_934_359
  end

  test "day3" do
    assert Day03.first() == 178_794_710
    assert Day03.second() == 76_729_637
  end
end
