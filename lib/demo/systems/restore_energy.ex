defmodule Demo.Systems.RestoreEnergy do
  @moduledoc """
  When the timer reaches zero, restore 1 energy to the hero.
  """

  use Ecspanse.System,
    lock_components: [Demo.Components.Energy],
    event_subscriptions: [Demo.Events.EnergyTimerFinished]

  @impl true
  def run(%Demo.Events.EnergyTimerFinished{entity_id: entity_id}, _frame) do
    with {:ok, entity} <- Ecspanse.Query.fetch_entity(entity_id),
         {:ok, energy} <- Ecspanse.Query.fetch_component(entity, Demo.Components.Energy) do
      Ecspanse.Command.update_component!(energy,
        current: energy.current + 1
      )
    end
  end
end
