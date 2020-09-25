defmodule Bio.Player.Event do
  def evaluate(event), do: apply(event.__struct__, :evaluate, [event])
end
