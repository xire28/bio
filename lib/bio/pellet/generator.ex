defmodule Bio.Pellet.Generator do
  alias Bio.{Pellet, Physic}

  @mass 1

  def create(), do: Pellet.new(Physic.Generator.create(@mass))
end
