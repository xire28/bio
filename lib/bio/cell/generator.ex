defmodule Bio.Cell.Generator do
  alias Bio.{Cell, Physic}

  @mass 1

  def create(), do: Cell.new(Physic.Generator.create(@mass))
end
