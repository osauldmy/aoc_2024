defmodule Aoc2024Test do
  use ExUnit.Case

  test "day1" do
    assert Day01.first() == 2_378_066
    assert Day01.second() == 18_934_359
  end

  test "day2" do
    assert Day02.first() == 371
    assert Day02.second() == 426
  end

  test "day3" do
    assert Day03.first() == 178_794_710
    assert Day03.second() == 76_729_637
  end

  test "day7" do
    assert Day07.first() == 975_671_981_569
    assert Day07.second() == 223_472_064_194_845
  end
end
