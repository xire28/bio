defmodule Bio.World.Generator do
  alias Bio.{Pellet, Virus, World}

  @min_pellets 200
  @min_viruses 20

  def create() do
    %World{
      pellets: Enum.take(Stream.repeatedly(&Pellet.Generator.create/0), @min_pellets),
      viruses: Enum.take(Stream.repeatedly(&Virus.Generator.create/0), @min_viruses)
    }
  end
end
