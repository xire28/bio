defmodule Bio.InteractionTest do
  alias Bio.{Cell, Interaction, Pellet, Physic, Player, Position, Virus}

  use ExUnit.Case
  use ExUnitProperties

  doctest Interaction

  test "try/1 without entities" do
    assert [] == Interaction.try([])
  end

  test "try/1 with one entity" do
    with pellet <- Pellet.Generator.create() do
      assert [pellet] == Interaction.try([pellet])
    end

    with name <- StreamData.binary() |> Enum.at(0),
         player <- Player.Generator.create(name) do
      assert [player] == Interaction.try([player])
    end

    with virus <- Virus.Generator.create() do
      assert [virus] == Interaction.try([virus])
    end
  end

  test "try/1 with many non-interacting entities" do
    check all num_pellets <- StreamData.positive_integer(),
              num_viruses <- StreamData.positive_integer() do
      with pellets <- Stream.repeatedly(&Pellet.Generator.create/0) |> Enum.take(num_pellets),
           viruses <- Stream.repeatedly(&Virus.Generator.create/0) |> Enum.take(num_viruses) do
        entities = pellets ++ viruses
        expected = entities
        actual = Interaction.try(entities)
        assert [] == expected -- actual
      end
    end
  end

  test "try/1 with many interacting entities" do
    check all mass <- StreamData.positive_integer(),
              x <- StreamData.positive_integer(),
              y <- StreamData.positive_integer(),
              num_pellets <- StreamData.positive_integer() do
      with physic <- %Physic{mass: mass, position: %Position{x: x, y: y}},
           pellets <-
             Stream.repeatedly(fn -> %{Pellet.Generator.create() | physic: physic} end)
             |> Enum.take(num_pellets) do
        player = %{
          Player.Generator.create(Enum.at(StreamData.binary(), 0))
          | cells: [%{Cell.Generator.create() | physic: physic}]
        }

        entities = [player | pellets]
        assert length(entities) > length(Interaction.try(entities))
      end
    end
  end
end
