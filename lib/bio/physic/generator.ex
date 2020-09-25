defmodule Bio.Physic.Generator do
  alias Bio.{Physic, Position}

  def create(mass), do: Physic.new(mass, Position.Generator.create())
end
