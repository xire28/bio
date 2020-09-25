defmodule Bio.Virus.Generator do
  alias Bio.{Physic, Virus}

  @min_mass 5
  @max_mass 10

  def create(), do: Virus.new(Physic.Generator.create(Enum.random(@min_mass..@max_mass)))
end
