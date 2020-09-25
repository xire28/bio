defmodule Bio.World do
  alias Bio.{Interaction, Pellet, Player, Virus}

  defstruct pellets: [], players: %{}, viruses: []

  defp entities(%__MODULE__{pellets: pellets, players: players, viruses: viruses}),
    do: pellets ++ Map.values(players) ++ viruses

  def num_pellets(%__MODULE__{pellets: pellets}), do: length(pellets)
  def num_players(%__MODULE__{players: players}), do: map_size(players)
  def num_viruses(%__MODULE__{viruses: viruses}), do: length(viruses)

  def add(%__MODULE__{} = world, %Pellet{} = pellet), do: update_in(world.pellets, &[pellet | &1])

  def add(%__MODULE__{} = world, %Player{id: id} = player),
    do: update_in(world.players[id], fn _ -> player end)

  def add(%__MODULE__{} = world, %Virus{} = virus), do: update_in(world.viruses, &[virus | &1])

  def tick(%__MODULE__{} = world) do
    entities(world)
    |> Interaction.try()
    |> Enum.reduce(%__MODULE__{}, &add(&2, &1))
  end
end
