defmodule Bio.Virus.Producer do
  alias Bio.{Virus, World}
  use GenServer

  @max 40

  @interval 500

  # Client

  def start_link(_) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  defp schedule_maybe_add() do
    Process.send_after(self(), :maybe_add, @interval)
  end

  # Server (callbacks)

  @impl true
  def init(_) do
    {:ok, %{timer: schedule_maybe_add()}}
  end

  @impl true
  def handle_info(:maybe_add, _) do
    [
      {{:_, :"$2", %World.Registry.Cache{num_pellets: :_, num_players: :_, num_viruses: :"$3"}},
       [{:<, :"$3", @max}], [{{:"$2"}}]}
    ]
    |> World.Registry.select()
    |> Enum.map(fn {agent} -> agent end)
    |> Enum.each(&World.Agent.add(&1, Virus.Generator.create()))

    {:noreply, %{timer: schedule_maybe_add()}}
  end

  @impl true
  def handle_info(_, state) do
    {:ok, state}
  end
end
