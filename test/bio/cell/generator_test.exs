defmodule Bio.Cell.GeneratorTest do
  alias Bio.Cell

  use ExUnit.Case
  doctest Cell.Generator

  test "create" do
    assert %Cell{} = Cell.Generator.create()
  end
end
