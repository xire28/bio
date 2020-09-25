defmodule Bio.Pellet do
  alias Bio.Physic

  @enforce_keys [:physic]
  defstruct [:physic]

  def new(%Physic{} = physic), do: %__MODULE__{physic: physic}
end
