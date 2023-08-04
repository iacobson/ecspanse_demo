defmodule Demo.Systems.MoveHero do
  @moduledoc """
  Checks if the hero has enough energy to move, then performs the move.
  """
  use Ecspanse.System,
    lock_components: [Demo.Components.Position, Demo.Components.Energy],
    event_subscriptions: [Demo.Events.MoveHero]

  alias Demo.Components

  @impl true
  def run(%Demo.Events.MoveHero{direction: direction}, _frame) do
    components =
      Ecspanse.Query.select({Components.Position, Components.Energy}, with: [Components.Hero])
      |> Ecspanse.Query.one()

    with {position, energy} <- components,
         :ok <- validate_enough_energy_to_move(energy) do
      Ecspanse.Command.update_components!([
        {energy, current: energy.current - 1},
        {position, update_coordinates(position, direction)}
      ])

      Ecspanse.event(Demo.Events.MaybeFindResources)
    end
  end

  defp validate_enough_energy_to_move(%Components.Energy{current: current_energy}) do
    if current_energy >= 1 do
      :ok
    else
      {:error, :not_enough_energy}
    end
  end

  defp update_coordinates(%Components.Position{x: x, y: y}, direction) do
    case direction do
      :up -> [x: x, y: y + 1]
      :down -> [x: x, y: y - 1]
      :left -> [x: x - 1, y: y]
      :right -> [x: x + 1, y: y]
    end
  end
end
