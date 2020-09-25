defmodule Bio.Position.GeneratorTest do
  alias Bio.Position

  use ExUnit.Case
  doctest Position.Generator

  test "create" do
    assert %Position{} = Position.Generator.create()
  end
end
