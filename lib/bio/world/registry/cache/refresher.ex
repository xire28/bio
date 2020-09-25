defmodule Bio.World.Registry.Cache.Refresher do
  alias Bio.World

  use GenServer

  @interval 1000

  # Client

  def start_link(_) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  defp schedule_refresh() do
    Process.send_after(self(), :refresh, @interval)
  end

  # Server (callbacks)

  @impl true
  def init(_) do
    {:ok, %{timer: schedule_refresh()}}
  end

  @impl true
  def handle_info(:refresh, _) do
    [{{:"$1", :"$2", :_}, [], [{{:"$1", :"$2"}}]}]
    |> World.Registry.select()
    |> Enum.each(fn {key, agent} ->
      Agent.cast(agent, fn world ->
        World.Registry.update_value(key, fn _ ->
          %World.Registry.Cache{
            num_pellets: World.num_pellets(world),
            num_players: World.num_players(world),
            num_viruses: World.num_viruses(world)
          }
        end)

        world
      end)
    end)

    {:noreply, %{timer: schedule_refresh()}}
  end

  @impl true
  def handle_info(_, state) do
    {:ok, state}
  end
end
