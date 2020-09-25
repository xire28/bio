defmodule Bio.Player.Event.Join do
  alias Bio.{Id, Player, World}

  @max 20

  @enforce_keys [:name]
  defstruct [:name]

  def evaluate(%__MODULE__{name: name} = event) do
    entry =
      [
        {{:"$1", :"$2",
          %World.Registry.Cache{num_pellets: :_, num_players: :"$3", num_viruses: :_}},
         [{:<, :"$3", @max}], [{{:"$1", :"$2"}}]}
      ]
      |> World.Registry.select()
      |> Enum.at(0)

    case entry do
      {world_id, agent} ->
        player = Player.Generator.create(name)
        World.Agent.add(agent, player)
        {player.id, world_id}

      nil ->
        World.DynamicSupervisor.start_child(%{
          id: Id.Generator.create(),
          start: {World.Generator, :create, []}
        })

        evaluate(event)
    end
  end
end
