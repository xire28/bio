defmodule Bio.Position.Generator do
  alias Bio.Position

  @max 1000

  def create(), do: Position.new(:rand.uniform(@max), :rand.uniform(@max))
end
