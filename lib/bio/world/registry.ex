defmodule Bio.World.Registry do
  def select(spec), do: Registry.select(__MODULE__, spec)
  def update_value(key, callback), do: Registry.update_value(__MODULE__, key, callback)
end
