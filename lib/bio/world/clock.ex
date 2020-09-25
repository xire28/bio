defmodule Bio.World.Clock do
  alias Bio.World
  use GenServer

  @interval 200

  # Client

  def start_link(_) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  defp schedule_tick() do
    Process.send_after(self(), :tick, @interval)
  end

  # Server (callbacks)

  @impl true
  def init(_) do
    {:ok, %{timer: schedule_tick()}}
  end

  @impl true
  def handle_info(:tick, _) do
    World.Registry.select([{{:_, :"$2", :_}, [], [{{:"$2"}}]}])
    |> Enum.map(fn {agent} -> agent end)
    |> Enum.each(&World.Agent.tick/1)

    {:noreply, %{timer: schedule_tick()}}
  end

  @impl true
  def handle_info(_, state) do
    {:ok, state}
  end
end
