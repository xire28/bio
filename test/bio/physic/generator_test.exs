defmodule Bio.Physic.GeneratorTest do
  alias Bio.Physic

  use ExUnit.Case
  doctest Physic.Generator

  test "create" do
    mass = 20
    assert %Physic{mass: mass} = Physic.Generator.create(mass)
  end
end
