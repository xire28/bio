defmodule Bio.PositionTest do
  alias Bio.Position

  use ExUnit.Case
  use ExUnitProperties

  doctest Position

  test "distance/2 property" do
    check all first_x <- StreamData.positive_integer(),
              first_y <- StreamData.positive_integer(),
              second_x <- StreamData.positive_integer(),
              second_y <- StreamData.positive_integer() do
      actual =
        Position.distance(%Position{x: first_x, y: first_y}, %Position{x: second_x, y: second_y})

      if first_x == second_x and first_y == second_y do
        assert actual == 0
      else
        assert actual > 0
      end
    end
  end

  test "distance/2" do
    first_position = %Position{x: 1, y: 2}
    second_position = %Position{x: 3, y: 4}

    assert Position.distance(first_position, second_position) == 2.8284271247461903
  end
end
