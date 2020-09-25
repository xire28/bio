defmodule Bio.Position do
  @enforce_keys [:x, :y]
  defstruct [:x, :y]

  def new(x, y) when is_integer(x) and is_integer(y) do
    %__MODULE__{x: x, y: y}
  end

  def distance(%__MODULE__{x: left_x, y: left_y}, %__MODULE__{x: right_x, y: right_y}) do
    :math.sqrt(:math.pow(left_x - right_x, 2) + :math.pow(left_y - right_y, 2))
  end
end
