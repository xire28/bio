defmodule Bio.Interaction do
  alias Bio.{Cell, Pellet, Physic, Sequence, Virus}

  # No interaction
  defp possible?(%Pellet{}, %Pellet{}), do: false
  defp possible?(%Pellet{}, %Virus{}), do: false
  defp possible?(%Virus{}, %Pellet{}), do: false
  defp possible?(%Virus{}, %Virus{}), do: false

  defp possible?(%{cells: cells}, %{physic: %Physic{}} = entity),
    do: Enum.any?(cells, &possible?(&1, entity))

  defp possible?(%{physic: %Physic{}} = entity, %{cells: _} = container),
    do: possible?(container, entity)

  defp possible?(%{cells: left_cells}, %{cells: right_cells}) do
    Enum.any?(left_cells, fn left_cell -> Enum.any?(right_cells, &possible?(&1, left_cell)) end)
  end

  defp possible?(%{physic: %Physic{} = left_physic}, %{physic: %Physic{} = right_physic}),
    do: Physic.collide?(left_physic, right_physic)

  defp make(%Cell{} = cell, %Pellet{physic: %Physic{mass: pellet_mass}}),
    do: [[update_in(cell.physic.mass, &(&1 + pellet_mass))], []]

  defp make(%Pellet{} = pellet, %Cell{} = cell), do: make(cell, pellet) |> Enum.reverse()

  defp make(
         %Cell{physic: %Physic{mass: cell_mass}} = cell,
         %Virus{physic: %Physic{mass: virus_mass}} = virus
       ) do
    cond do
      cell_mass > virus_mass ->
        cell = update_in(cell.physic.mass, &(&1 + virus_mass))

        if cell_mass > virus_mass * 2 do
          [[cell], []]
        else
          [Cell.split(cell, 5), []]
        end

      true ->
        [[cell], [virus]]
    end
  end

  defp make(%Virus{} = virus, %Cell{} = cell), do: make(cell, virus) |> Enum.reverse()

  defp make(
         %Cell{physic: %Physic{mass: left_mass}} = left_cell,
         %Cell{physic: %Physic{mass: right_mass}} = right_cell
       ) do
    cond do
      left_mass > right_mass -> [[update_in(left_cell.physic.mass, &(&1 + right_mass))], []]
      left_mass == right_mass -> [[left_cell], [right_cell]]
      left_mass < right_mass -> [[], [update_in(right_cell.physic.mass, &(&1 + left_mass))]]
    end
  end

  defp make(%{cells: cells} = container, %{physic: %Physic{}} = entity) do
    random_cells = Enum.shuffle(cells)

    if index =
         random_cells
         |> Enum.find_index(&possible?(&1, entity)) do
      [left_outcome, right_outcome] =
        random_cells
        |> Enum.at(index)
        |> make(entity)

      [
        update_in(container.cells, fn _ -> left_outcome ++ List.delete_at(random_cells, index) end),
        right_outcome
      ]
    else
      [[container], [entity]]
    end
  end

  defp make(%{physic: %Physic{}} = entity, %{cells: _} = container),
    do: make(container, entity) |> Enum.reverse()

  defp make(%{cells: left_cells} = left_container, %{cells: right_cells} = right_container) do
    left_random_cells = Enum.shuffle(left_cells)
    right_random_cells = Enum.shuffle(right_cells)

    left_indexes = 0..(length(left_random_cells) - 1)
    right_indexes = 0..(length(right_random_cells) - 1)

    {{left_consumed_indexes, right_consumed_indexes},
     [left_updated_entities, right_updated_entities]} =
      left_indexes
      |> Sequence.combine(right_indexes)
      |> Enum.reduce({{[], []}, [[], []]}, fn [left_index, right_index],
                                              {{left_consumed_indexes, right_consumed_indexes} =
                                                 nested_consumed_indexes,
                                               [left_updated_entities, right_updated_entities] =
                                                 nested_updated_entities} ->
        case not Enum.member?(left_consumed_indexes, left_index) and
               not Enum.member?(right_consumed_indexes, right_index) do
          true ->
            case try(Enum.at(left_cells, left_index), Enum.at(right_cells, right_index)) do
              {:ok, [left_outcome, right_outcome]} ->
                {{[left_index | left_consumed_indexes], [right_index | right_consumed_indexes]},
                 [left_outcome ++ left_updated_entities, right_outcome ++ right_updated_entities]}

              {:error, _} ->
                {nested_consumed_indexes, nested_updated_entities}
            end

          false ->
            {nested_consumed_indexes, nested_updated_entities}
        end
      end)

    left_non_consumed_entities =
      left_indexes
      |> Sequence.difference(left_consumed_indexes)
      |> Enum.map(&Enum.at(left_random_cells, &1))

    right_non_consumed_entities =
      right_indexes
      |> Sequence.difference(right_consumed_indexes)
      |> Enum.map(&Enum.at(right_random_cells, &1))

    case {left_updated_entities ++ left_non_consumed_entities,
          right_updated_entities ++ right_non_consumed_entities} do
      {[], []} ->
        [[], []]

      {new_left_cells, []} ->
        [update_in(left_container.cells, fn _ -> new_left_cells end), []]

      {[], new_right_cells} ->
        [[], update_in(right_container.cells, fn _ -> new_right_cells end)]

      {new_left_cells, new_right_cells} ->
        [
          update_in(left_container.cells, fn _ -> new_left_cells end),
          update_in(right_container.cells, fn _ -> new_right_cells end)
        ]
    end
  end

  # No interaction
  defp make(%{physic: %Physic{}} = left_entity, %{physic: %Physic{}} = right_entity),
    do: [[left_entity], [right_entity]]

  def try(left_entity, right_entity) do
    if possible?(left_entity, right_entity),
      do: {:ok, make(left_entity, right_entity)},
      else: {:error, [[left_entity], [right_entity]]}
  end

  def try([]), do: []

  def try(entities) when is_list(entities) do
    entities = Enum.shuffle(entities)

    indexes = 0..(length(entities) - 1)

    {consumed_indexes, updated_entities} =
      indexes
      |> Sequence.combine()
      |> Enum.reduce({[], []}, fn [left_index, right_index] = indexes,
                                  {consumed_indexes, updated_entities} ->
        case length(indexes -- consumed_indexes) do
          2 ->
            case try(Enum.at(entities, left_index), Enum.at(entities, right_index)) do
              {:ok, outcomes} ->
                {indexes ++ consumed_indexes, List.flatten(outcomes, updated_entities)}

              {:error, _} ->
                {consumed_indexes, updated_entities}
            end

          _ ->
            {consumed_indexes, updated_entities}
        end
      end)

    non_consumed_entities =
      indexes
      |> Sequence.difference(consumed_indexes)
      |> Enum.map(&Enum.at(entities, &1))

    updated_entities ++ non_consumed_entities
  end
end
