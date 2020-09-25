defmodule Bio.Cell do
  alias Bio.Physic

  @enforce_keys [:physic]
  defstruct [:physic]

  def new(%Physic{} = physic), do: %__MODULE__{physic: physic}
  def mass(%__MODULE__{physic: %Physic{mass: mass}}), do: mass

  def split(cell, num) when is_integer(num) and num > 0 do
    cell_mass = div(mass(cell), num)
    for _ <- 1..num, do: update_in(cell.physic.mass, fn _ -> cell_mass end)
  end
end
