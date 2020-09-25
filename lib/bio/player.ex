defmodule Bio.Player do
  @enforce_keys [:id, :name, :cells]
  defstruct [:id, :name, :cells]

  def new(id, name, cells) when is_integer(id) and is_binary(name) and is_list(cells) do
    %__MODULE__{id: id, name: name, cells: cells}
  end
end
