defmodule Bio.PelletTest do
  alias Bio.{Physic, Pellet, Position}

  use ExUnit.Case
  use ExUnitProperties

  doctest Pellet

  test "new/1" do
    check all mass <- StreamData.positive_integer(),
              x <- StreamData.positive_integer(),
              y <- StreamData.positive_integer() do
      physic = %Physic{mass: mass, position: %Position{x: x, y: y}}
      expected = %Pellet{physic: physic}
      actual = Pellet.new(physic)

      assert expected == actual
    end
  end
end
