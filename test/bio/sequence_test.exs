defmodule Bio.SequenceTest do
  alias Bio.Sequence

  use ExUnit.Case
  use ExUnitProperties

  doctest Sequence

  test "combine/2 property" do
    check all first_range_start <- StreamData.positive_integer(),
              first_range_length <- StreamData.positive_integer(),
              second_range_start <- StreamData.positive_integer(),
              second_range_length <- StreamData.positive_integer() do
      first_range = first_range_start..(first_range_start + first_range_length)
      second_range = second_range_start..(second_range_start + second_range_length)

      expected = Sequence.combine(second_range, first_range) |> length
      actual = Sequence.combine(first_range, second_range) |> length

      assert expected == actual
    end
  end

  test "combine/2" do
    assert [[0, 0], [0, 1], [1, 1]] = Sequence.combine(0..1, 0..1)
  end

  test "combine/1" do
    assert [[0, 1], [0, 2], [1, 2]] = Sequence.combine(0..2)
  end
end
