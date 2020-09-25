defmodule Bio.Sequence do
  def combine(%Range{} = left_range, %Range{} = right_range, filter \\ fn _, _ -> true end) do
    Stream.flat_map(left_range, fn i ->
      for j <- right_range, filter.(i, j), do: [i, j]
    end)
    |> Enum.uniq_by(&Enum.sort/1)
  end

  def combine(range), do: combine(range, range, &!=/2)

  def difference(%Range{} = range, list) when is_list(list) do
    MapSet.new(range) |> MapSet.difference(MapSet.new(list))
  end
end
