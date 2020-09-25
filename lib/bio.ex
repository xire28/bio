defmodule Bio do
  alias Bio.{Pellet, Virus, World}

  use Application

  @moduledoc """
  	Agar.io clone
  """

  def start(_args, _opts) do
    children = [
      {World.DynamicSupervisor, []},
      {Registry, keys: :unique, name: World.Registry},
      {World.Clock, []},
      {Pellet.Producer, []},
      {Virus.Producer, []},
      {World.Registry.Cache.Refresher, []}
    ]

    opts = [strategy: :one_for_one, name: __MODULE__]
    Supervisor.start_link(children, opts)
  end
end
