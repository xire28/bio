defmodule Bio.Player.Event.Leave do
  @enforce_keys [:world_id, :player_id]
  defstruct [:world_id, :player_id]

  def evaluate(%__MODULE__{world_id: world_id, player_id: player_id}) do
    IO.inspect([world_id, player_id])
  end
end
