defmodule Bio.Player.Event.Move do
  alias Bio.Position

  @enforce_keys [:world_id, :player_id, :position]
  defstruct [:world_id, :player_id, :position]

  def evaluate(%__MODULE__{
        world_id: world_id,
        player_id: player_id,
        position: %Position{x: x, y: y}
      }) do
    IO.inspect([world_id, player_id, x, y])
  end
end
