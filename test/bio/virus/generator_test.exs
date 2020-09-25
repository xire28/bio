defmodule Bio.Virus.GeneratorTest do
  alias Bio.Virus

  use ExUnit.Case
  doctest Virus.Generator

  test "create" do
    assert %Virus{} = Virus.Generator.create()
  end
end
