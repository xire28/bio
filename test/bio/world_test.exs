defmodule Bio.WorldTest do
  alias Bio.{Pellet, Player, Virus, World}

  use ExUnit.Case
  use ExUnitProperties

  doctest World

  test "add/2" do
    pellet = Pellet.Generator.create()
    assert %World{pellets: [pellet]} = World.add(%World{}, pellet)

    (%Player{id: player_id} = player) =
      StreamData.binary()
      |> Enum.at(0)
      |> Player.Generator.create()

    assert %World{players: %{^player_id => player}} = World.add(%World{}, player)

    virus = Virus.Generator.create()
    assert %World{viruses: [virus]} = World.add(%World{}, virus)
  end

  test "tick/1" do
    pallets = [Pellet.Generator.create()]
    viruses = [Virus.Generator.create()]

    player =
      Enum.at(StreamData.binary(), 0)
      |> Player.Generator.create()

    players = %{player.id => player}

    assert %World{} = World.tick(%World{pellets: pallets, players: players, viruses: viruses})
  end
end
