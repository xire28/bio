defmodule Bio.Physic do
  alias Bio.Position

  @enforce_keys [:mass, :position]
  defstruct [:mass, :position]

  def new(mass, position) when mass > 0, do: %__MODULE__{mass: mass, position: position}

  def collide?(%__MODULE__{mass: left_mass, position: left_position}, %__MODULE__{
        mass: right_mass,
        position: right_position
      }) do
    Position.distance(left_position, right_position) < left_mass + right_mass
  end
end
