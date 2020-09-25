defmodule Bio.World.DynamicSupervisor do
  alias Bio.World

  use DynamicSupervisor

  # Client

  def start_link(init_arg) do
    DynamicSupervisor.start_link(__MODULE__, init_arg, name: __MODULE__)
  end

  def start_child(%{id: id, start: start}) do
    DynamicSupervisor.start_child(
      __MODULE__,
      {World.Agent,
       start: start, name: {:via, Registry, {World.Registry, id, %World.Registry.Cache{}}}}
    )
  end

  # Server (callbacks)

  @impl true
  def init(_init_arg) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end
end
