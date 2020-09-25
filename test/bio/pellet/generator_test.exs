defmodule Bio.Pellet.GeneratorTest do
  alias Bio.Pellet

  use ExUnit.Case
  doctest Pellet.Generator

  test "create" do
    assert %Pellet{} = Pellet.Generator.create()
  end
end
