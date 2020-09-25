defmodule Bio.Player.Generator do
  alias Bio.{Cell, Id, Player}

  def create(name), do: Player.new(Id.Generator.create(), name, [Cell.Generator.create()])
end
