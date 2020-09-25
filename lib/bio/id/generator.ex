defmodule Bio.Id.Generator do
  def create(), do: System.unique_integer([:monotonic, :positive])
end
