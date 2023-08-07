defmodule Demo.Systems.MaybeFindResources do
  @moduledoc """
  The hero has a chance to find resources at the current position.
  """
  use Ecspanse.System,
    lock_components: [Demo.Components.Gems, Demo.Components.Gold],
    event_subscriptions: [Ecspanse.Event.ComponentUpdated]

  alias Demo.Components

  @impl true
  def run(%Ecspanse.Event.ComponentUpdated{component: %Demo.Components.Position{}}, _frame) do
    with true <- found_resource?(),
         resource_module <- pick_resource(),
         {:ok, hero_entity} <- Demo.Entities.Hero.fetch(),
         {:ok, resource} <- Ecspanse.Query.fetch_component(hero_entity, resource_module) do
      Ecspanse.Command.update_component!(resource, amount: resource.amount + 1)
    end
  end

  def run(_event, _frame), do: :ok

  defp found_resource?, do: Enum.random([true, false])
  defp pick_resource, do: Enum.random([Components.Gems, Components.Gold])
end
