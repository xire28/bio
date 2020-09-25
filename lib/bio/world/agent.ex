defmodule Bio.World.Agent do
  alias Bio.World

  use Agent, restart: :transient

  def start_link(opts) do
    {{mod, fun, args}, opts} = Keyword.pop(opts, :start, 0)
    Agent.start_link(fn -> apply(mod, fun, args) end, opts)
  end

  def get(agent), do: Agent.get(agent, & &1)

  def add(agent, entity), do: Agent.cast(agent, &World.add(&1, entity))

  def tick(agent), do: Agent.cast(agent, &World.tick(&1))
end
