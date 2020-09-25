defmodule Bio.CellTest do
  alias Bio.{Cell, Physic, Position}

  use ExUnit.Case
  use ExUnitProperties

  doctest Cell

  test "new/1" do
    check all mass <- StreamData.positive_integer(),
              x <- StreamData.positive_integer(),
              y <- StreamData.positive_integer() do
      physic = %Physic{mass: mass, position: %Position{x: x, y: y}}
      expected = %Cell{physic: physic}
      actual = Cell.new(physic)

      assert expected == actual
    end
  end

  test "split/2" do
    check all num <- StreamData.positive_integer(),
              x <- StreamData.positive_integer(),
              y <- StreamData.positive_integer() do
      cell = %Cell{physic: %Physic{mass: num, position: %Position{x: x, y: y}}}
      split_cell = %Cell{physic: %Physic{mass: 1, position: %Position{x: x, y: y}}}

      expected =
        Stream.repeatedly(fn -> split_cell end)
        |> Enum.take(num)

      actual = Cell.split(cell, num)

      assert expected == actual
    end
  end
end
