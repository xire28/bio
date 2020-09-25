defmodule Bio.Player.GeneratorTest do
  alias Bio.Player

  use ExUnit.Case
  doctest Player.Generator

  test "create" do
    name = "test"
    assert %Player{name: name} = Player.Generator.create(name)
  end
end
