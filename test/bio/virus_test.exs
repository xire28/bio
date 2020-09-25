defmodule Bio.VirusTest do
  alias Bio.{Physic, Position, Virus}

  use ExUnit.Case
  use ExUnitProperties

  doctest Virus

  test "new/1" do
    check all mass <- StreamData.positive_integer(),
              x <- StreamData.positive_integer(),
              y <- StreamData.positive_integer() do
      physic = %Physic{mass: mass, position: %Position{x: x, y: y}}
      expected = %Virus{physic: physic}
      actual = Virus.new(physic)

      assert expected == actual
    end
  end
end
