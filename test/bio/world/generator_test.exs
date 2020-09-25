defmodule Bio.World.GeneratorTest do
  alias Bio.World

  use ExUnit.Case
  doctest World.Generator

  test "create" do
    assert %World{} = World.Generator.create()
  end
end
