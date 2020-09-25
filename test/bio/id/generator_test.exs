defmodule Bio.Id.GeneratorTest do
  alias Bio.Id

  use ExUnit.Case
  doctest Id.Generator

  test "create/0" do
    id = Id.Generator.create()
    assert is_integer(id)
    assert id > 0
  end
end
