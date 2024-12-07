defmodule Day05 do
  defp example,
    do: """
    47|53
    97|13
    97|61
    97|47
    75|29
    61|13
    75|53
    29|13
    97|29
    53|29
    61|53
    97|53
    61|29
    47|13
    75|47
    97|75
    47|61
    75|61
    47|29
    75|13
    53|13

    75,47,61,53,29
    97,61,53,29,13
    75,29,13
    75,97,47,61,53
    61,13,29
    97,13,75,29,47
    """

  defp read_input, do: File.read!("inputs/05.txt")

  def preprocess_input do
    # example()
    read_input()
    |> String.split("\n\n")
    |> Enum.map(&String.split(&1, "\n", trim: true))
  end

  def first do
    [raw_rules, raw_updates] = preprocess_input()

    rules =
      Enum.map(raw_rules, fn ruleset ->
        String.split(ruleset, "|") |> Enum.map(&String.to_integer/1)
      end)

    rules_map =
      Enum.reduce(rules, %{}, fn [a, b], rules_map ->
        Map.update(rules_map, b, [a], &(&1 ++ [a]))
      end)

    updates =
      Enum.map(raw_updates, fn update_set ->
        String.split(update_set, ",") |> Enum.map(&String.to_integer/1)
      end)

    updates
    |> Enum.filter(&update_correct?(&1, rules_map))
    |> Enum.map(&take_middle_of_the_list/1)
    |> Enum.sum()
  end

  defp update_correct?(update, rules_map) do
    Enum.reduce(update, {true, MapSet.new([])}, fn page, acc ->
      {was_correct, already_seen} = acc

      still_correct =
        Map.get(rules_map, page, [])
        |> Enum.map(fn constraint ->
          if constraint in update,
            do: constraint in already_seen,
            else: constraint not in already_seen
        end)
        |> Enum.all?()

      {was_correct and still_correct, MapSet.put(already_seen, page)}
    end)
    |> elem(0)
  end

  defp take_middle_of_the_list(list) when is_list(list), do: Enum.at(list, div(length(list), 2))

  def second do
  end
end
